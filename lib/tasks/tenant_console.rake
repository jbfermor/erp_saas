namespace :tenant do
  desc "Abre una consola Rails dentro del tenant indicado. Uso: rake tenant:console[slug]"
  task :console, [:slug] => :environment do |t, args|
    slug = args[:slug]

    if slug.nil?
      puts "❌ ERROR: Debes indicar un slug. Ejemplo:"
      puts "    rake tenant:console[cliente1]"
      exit 1
    end

    tenant = SaasTenantDatabase.find_by(slug: slug) rescue nil
    if tenant.nil?
      puts "❌ ERROR: No existe un tenant con slug '#{slug}'."
      exit 1
    end

    puts "🔄 Cambiando contexto al tenant: #{slug}"

    # Activamos el tenant antes de entrar en consola interactiva
    TenantContext.switch(slug) do
      puts "🟢 Conexión establecida con la base de datos del tenant #{slug}"
      puts "👉 Abriendo consola…"
      
      # Abre irb dentro del contexto del tenant
      require "irb"
      ARGV.clear
      IRB.start
    end
  end
end
