# app/models/saas/account.rb
require "pg"

module Saas
  class Account < ApplicationRecord
    has_one :tenant_database, class_name: "Saas::TenantDatabase", dependent: :destroy

    has_many :subscriptions, class_name: "Saas::Subscription", dependent: :destroy
    has_many :modules, through: :subscriptions, class_name: "Saas::Module"

    belongs_to :plan, class_name: "Saas::Plan", optional: true
    has_one :company, class_name: "Core::Company", dependent: :destroy

    validates :name, :slug, :subdomain, :database_name, presence: true
    validates :slug, :subdomain, uniqueness: true

    # Parámetros temporales para la base de datos (llegan desde el front)
    attr_accessor :tenant_database_params

    after_commit :enqueue_tenant_provisioner, on: :create

    private

    def enqueue_tenant_provisioner
      Saas::TenantProvisionerJob.perform_later(self.id)
    end
  end
end
