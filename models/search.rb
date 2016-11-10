# frozen_string_literal: true

# Represents a Group's stored information
class Search < Sequel::Model
  one_to_many :songs
end
