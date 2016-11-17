# frozen_string_literal: true

# Represents a Group's stored information
class Song < Sequel::Model
  many_to_one :search
end
