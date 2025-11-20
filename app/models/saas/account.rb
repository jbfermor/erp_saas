# app/models/saas/account.rb
require "pg"

module Saas
  class Account < ApplicationRecord
    has_one :saas_tenant_database, class_name: "Saas::TenantDatabase", dependent: :destroy
    accepts_nested_attributes_for :saas_tenant_database

    has_many :subscriptions, class_name: "Saas::Subscription", dependent: :destroy
    has_many :modules, through: :subscriptions, class_name: "Saas::Module"

    belongs_to :plan, class_name: "Saas::Plan", optional: true

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
