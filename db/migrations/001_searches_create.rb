# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:searches) do
      primary_key :search_id
      String :input
    end
  end
end
