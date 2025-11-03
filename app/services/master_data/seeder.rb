# app/services/master_data/seeder.rb
# Servicio para replicar tablas master_data desde la DB madre a la DB tenant
# Uso: MasterData::Seeder.new(account).seed!
module MasterData
  class Seeder
    # account: Saas::Account (registro en la DB madre), debe tener tenant_database asociado
    def initialize(account, logger: Rails.logger)
      @account = account
      @tenant_db = account.tenant_database
      @logger = logger
      raise ArgumentError, "tenant_database required on account" unless @tenant_db.present?
    end

    # Ejecuta la réplica completa. Idempotente.
    def seed!
      @logger.info("[MasterData::Seeder] Inicio seed para tenant=#{@account.slug}")
      source_models = discover_master_data_models

      TenantSwitcher.switch(@account) do
        # dentro del contexto de la base tenant: aplicar inserciones/updates
        source_models.each do |model_class|
          replicate_model(model_class)
        end
      end

      @logger.info("[MasterData::Seeder] Fin seed para tenant=#{@account.slug}")
      true
    rescue => e
      @logger.error("[MasterData::Seeder] Error en seed tenant=#{@account.slug}: #{e.class} #{e.message}")
      raise
    end

    private

    # Lista de modelos master_data a replicar. Añadir aquí los modelos que quieras.
    # Solo modelos del namespace MasterData.
    def discover_master_data_models
      # Lista explícita para control y orden; evita reflexiva que falle si hay modelos no deseados.
      [
        MasterData::Role,
        MasterData::EntityType,
        MasterData::DocumentType,
        MasterData::TaxType,
        MasterData::AddressType,
        MasterData::Country
      ].freeze
    end

    # Replica los registros de un modelo concreto.
    # - Filtra registros 'saas-only' según políticas (por ejemplo scope: 'tenant')
    # - Inserta o actualiza (upsert) en el tenant por code (o por unique key)
    def replicate_model(source_model)
      @logger.info("[MasterData::Seeder] Replicando #{source_model.name}...")

      # Query en la DB madre (source)
      source_records = filter_source_records(source_model).to_a
      @logger.info("[MasterData::Seeder] Encontrados #{source_records.size} registros en #{source_model.name}")

      # Modelo equivalente dentro del tenant: asumimos mismo nombre en namespace MasterData
      tenant_model = source_model # dentro del tenant el mismo constant_name apunta a MasterData::<X>

      # Para cada registro: upsert por `code` si existe, o por slug/unique key.
      source_records.each do |src|
        attrs = src.attributes.except("id", "created_at", "updated_at")
        # Normalize: remove nil keys that tenant model may not accept
        attrs = attrs.select { |k, v| tenant_model.column_names.include?(k) }

        # Upsert: find_or_initialize_by(code: ...) then update!
        if attrs["code"].present?
          record = tenant_model.find_or_initialize_by(code: attrs["code"])
          record.assign_attributes(attrs)
          record.save!
        else
          # fallback por campo 'slug' o por una combinación de campos
          key_field = (["slug"] & tenant_model.column_names).first
          if key_field
            record = tenant_model.find_or_initialize_by(key_field => attrs[key_field])
            record.assign_attributes(attrs)
            record.save!
          else
            # Si no existe clave única, intentamos crear por duplicado controlado
            tenant_model.create!(attrs) rescue nil
          end
        end
      end

      @logger.info("[MasterData::Seeder] Replicado #{source_model.name}: OK")
    end

    # Filtra los registros que deben copiarse desde la DB madre.
    # Ejemplo: roles -> solo scope = 'tenant'
    def filter_source_records(model)
      case model.name
      when "MasterData::Role"
        model.where(scope: "tenant")
      else
        model.all
      end
    end
  end
end
