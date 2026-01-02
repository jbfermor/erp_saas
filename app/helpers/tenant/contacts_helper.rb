module Tenant::ContactsHelper
  def entity_display_name(entity)
    case entity.entity_type.slug
    when "individual"
      if entity.personal_info
        "#{entity.personal_info.name} #{entity.personal_info.surnames}"
      else
        "Persona sin datos"
      end
    when "business"
      entity.business_info&.trade_name || "Empresa sin datos"
    else
      "Entidad"
    end
  end
end
