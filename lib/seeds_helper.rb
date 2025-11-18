# frozen_string_literal: true

module SeedsHelper
  def table_exists?(table_name)
    ActiveRecord::Base.connection.data_source_exists?(table_name)
  rescue ActiveRecord::NoDatabaseError, PG::ConnectionBad
    false
  end
end
