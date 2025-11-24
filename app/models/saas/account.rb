# app/models/saas/account.rb
require "pg"

module Saas
  class Account < ApplicationRecord
    has_one :saas_tenant_database, class_name: "Saas::TenantDatabase", 
            foreign_key: :saas_account_id, dependent: :destroy
    accepts_nested_attributes_for :saas_tenant_database

    validates :name, :slug, :subdomain, presence: true
    validates :slug, :subdomain, uniqueness: true

    # Parámetros temporales para la base de datos (llegan desde el front)
    attr_accessor :tenant_database_params

    after_commit :enqueue_tenant_provisioner, on: :create

    def setup_tenant!(tenant_database_data:, saas_account:, company_data:, owner_email:, owner_name: nil, owner_password: "changeme")

      Saas::TenantSetupService.new(
        tenant_database_data: tenant_database_data,
        saas_account: self,
        company_data: company_data,
        owner_email: owner_email,
        owner_name: owner_name,
        owner_password: owner_password
      ).call
    end

    private

    def enqueue_tenant_provisioner
      Saas::TenantProvisionerJob.perform_later(self.id)
    end


  end
end
