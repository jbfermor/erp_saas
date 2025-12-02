module MasterData
  class DatabaseConfig < ApplicationRecord
    self.table_name = "master_data_database_configs"

    belongs_to :company, class_name: "Core::Company"
  end
end
