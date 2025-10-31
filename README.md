### Arquitectura y conceptos clave: 

#### 1. Modularidad 

- **Core**: funcionalidades mínimas y reutilizables que se usan en cualquier tenant: - Modelos: User, Role, Company (antes Account, representa la “compañía” del tenant), CustomAttribute, CustomValue. - Roles base: super_admin, admin, staff, user. - Core maneja permisos base, usuarios, roles y datos comunes. 
- **Saas**: funcionalidades exclusivas del admin del SaaS: - Modelos: Account (la account madre y las accounts de clientes), Subscription, Module. - Admin de la SaaS controla la creación de accounts y asigna módulos contratados. - Cada tenant solo puede acceder a sus datos, salvo que el staff de la account madre necesite soporte. 
- **Módulos del SaaS**: 
 Representan funcionalidades concretas (Inventory, Billing, Sales, etc.). 
- Cada módulo tiene sus propios modelos, vistas y controladores. 
- Si un módulo está contratado por un account, los roles de esa account pueden usarlo según permisos. 
- Permisos: expresos por rol y por módulo activo; se almacenan en tablas (no enums). 

#### 2. Usuarios y roles 
- User existe en Core y puede tener roles asignados. 
- Roles controlan acceso a módulos y acciones dentro de ellos. 
- Super_admin y admin de la account madre pueden actuar sobre todas las accounts excepto la account madre. 
- Staff limitado puede hacer soporte o modificar información dentro de su nivel de permisos. 
- Customers pueden ser usuarios normales de un account y solo pueden acceder a ciertas acciones de módulos. 

#### 3. Multi-tenant 
- Cada account tiene su propia base de datos. 
- Account madre crea, modifica y elimina tenants manualmente. 
- Los usuarios de un tenant solo existen en la DB de esa account. 
- Provisioning de DB de tenant: realizado por admin, usuario creado automáticamente con rol owner. 
- Roles y permisos se gestionan dentro de Core y asociados a módulos activos. 

#### 4. Seguridad y rutas 
- Nunca mostrar IDs de objetos en rutas. Usar slugs o UUIDs. 
- Acciones sensibles protegidas por roles y permisos. 
- Super_admin tiene privilegios únicos; su eliminación/modificación está prohibida. 
- Comprobación de permisos a nivel de módulo y acción. 

#### 5. Integraciones 
- **Frontend**: Bootstrap 5.3 
- **Autenticación**: Devise 
- **Background jobs**: Sidekiq + Redis 
- **Emails**: SendGrid 
- **Pagos**: Stripe (Checkout y webhooks) 
- **Env management**: dotenv-rails 
- **TDD**: RSpec + FactoryBot + Faker - Todos los tests se escriben 
- **antes de implementar** (TDD). 

### Objetivos 
. Crear la app base y configurar gems, DB, dotenv, bootstrap. 
2. Generar modelos Core (User, Role, Company, etc.) con tests y factories. 
3. Crear seeds iniciales (super_admin, account madre, roles base). 
4. Generar modelos y migraciones de módulos Saas (Account, Module, Subscription) correctamente relacionados. 
5. Configurar Stripe, Sidekiq, Devise y roles paso a paso. 
6. Escribir tests de modelos y controladores antes de implementar. 
7. Documentar todo paso a paso y versionar con commits de Git. 8. Asegurar rutas sin IDs, control de permisos y seguridad de super_admin.