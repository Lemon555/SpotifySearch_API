# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:searchs) do
      primary_key :id
      String :input
    end
  end
end
