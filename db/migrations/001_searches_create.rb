# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:searches) do
      primary_key :id
      String :input
    end
  end
end
