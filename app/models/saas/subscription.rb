class Saas::Subscription < ApplicationRecord
  belongs_to :account
  belongs_to :module
end
