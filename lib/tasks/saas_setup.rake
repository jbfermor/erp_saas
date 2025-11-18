# lib/tasks/saas_setup.rake
namespace :saas do
  desc "Inicializa el entorno completo del ERP SaaS (bases de datos, seeds y cuenta madre)"
  task setup_environment: :environment do
    puts "🚀 Iniciando configuración completa del entorno SaaS..."

    # 1️⃣ Verificar variables de entorno
    required_envs = %w[
      SAAS_DB_NAME SAAS_DB_USER SAAS_DB_PASS SAAS_DB_HOST SAAS_DB_PORT
      MASTER_DB_NAME MASTER_DB_USER MASTER_DB_PASS MASTER_DB_HOST MASTER_DB_PORT
    ]

    missing_envs = required_envs.select { |var| ENV[var].blank? }
    unless missing_envs.empty?
      abort("❌ Faltan variables de entorno: #{missing_envs.join(', ')}")
    end

    # 2️⃣ Comprobar conexión a ambas bases
    puts "🔌 Verificando conexiones..."
    check_database_connection(ENV['SAAS_DB_NAME'], ENV['SAAS_DB_USER'], ENV['SAAS_DB_HOST'], ENV['SAAS_DB_PORT'])
    check_database_connection(ENV['MASTER_DB_NAME'], ENV['MASTER_DB_USER'], ENV['MASTER_DB_HOST'], ENV['MASTER_DB_PORT'])

    # 3️⃣ Ejecutar seeds en la base de datos SaaS
    puts "🌱 Ejecutando seeds en base de datos SaaS..."
    ENV["DATABASE_URL"] = "postgres://#{ENV['SAAS_DB_USER']}:#{ENV['SAAS_DB_PASS']}@#{ENV['SAAS_DB_HOST']}:#{ENV['SAAS_DB_PORT']}/#{ENV['SAAS_DB_NAME']}"
    system("bin/rails db:schema:load && bin/rails db:seed")

    # 4️⃣ Crear account madre (si no existe)
    puts "🏗 Creando o verificando account madre..."
    require_relative "../../app/models/saas/account"
    global_plan = Saas::Plan.find_by(code: "saas")
    unless global_plan
      abort("❌ No existe el plan global. Revisa el seed de Saas::Plan.")
    end

    mother_account = Saas::Account.find_or_create_by!(slug: "master") do |acc|
      acc.name = "SaaS Master"
      acc.subdomain = "master"
      acc.database_name = ENV['MASTER_DB_NAME']
      acc.plan = global_plan
    end

    # Crear o actualizar tenant_database asociado
    mother_account.create_tenant_database!(
      host: ENV['MASTER_DB_HOST'],
      port: ENV['MASTER_DB_PORT'],
      username: ENV['MASTER_DB_USER'],
      password: ENV['MASTER_DB_PASS'],
      database_name: ENV['MASTER_DB_NAME']
    )

    puts "✅ Account madre configurada correctamente."

    # 5️⃣ Ejecutar seeds en la base de datos MASTER
    puts "🌱 Ejecutando seeds en base de datos MASTER..."
    ENV["DATABASE_URL"] = "postgres://#{ENV['MASTER_DB_USER']}:#{ENV['MASTER_DB_PASS']}@#{ENV['MASTER_DB_HOST']}:#{ENV['MASTER_DB_PORT']}/#{ENV['MASTER_DB_NAME']}"
    system("bin/rails db:schema:load && bin/rails db:seed")

    puts "✅ Entorno inicializado correctamente ✅"
  end

  # ------------------------------------------------------
  # Métodos auxiliares
  # ------------------------------------------------------
  def check_database_connection(db_name, db_user, db_host, db_port)
    require "pg"
    conn = PG.connect(dbname: db_name, user: db_user, host: db_host, port: db_port)
    conn.close
    puts "✅ Conexión exitosa con #{db_name} (#{db_host}:#{db_port})"
  rescue PG::Error => e
    abort("❌ Error al conectar con #{db_name}: #{e.message}")
  end
end
