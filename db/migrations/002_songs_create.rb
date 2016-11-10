# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:songs) do
      primary_key :track_id
      foreign_key :search_id

      String :track_name
      String :artists
      String :album
      String :link
      String :images
      String :updated_time
    end
  end
end
