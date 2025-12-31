module MasterData
  class DatabaseConfig < ApplicationRecord
    belongs_to :company, class_name: "Core::Company"
  end
end
