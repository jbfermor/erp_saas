module Saas
  class Subscription < ApplicationRecord
    belongs_to :account, class_name: "Saas::Account"
    belongs_to :module, class_name: "Saas::Module"

    validates :account_id, uniqueness: { scope: :module_id, message: "ya tiene suscripción para este módulo" }

    validates :started_at, :expires_at, :status, presence: true
  end
end
