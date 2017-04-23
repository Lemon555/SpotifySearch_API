# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:songs) do
      primary_key :id
      foreign_key :search_id

      String :track_name
      String :track_id
      String :artists_secure
      String :album
      String :link
      String :images
    end
  end
end
