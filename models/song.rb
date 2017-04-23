# frozen_string_literal: true

# Represents a Group's stored information
class Song < Sequel::Model
  many_to_one :search

  def artists=(artists_plain)
    self.artists_secure = SecureDB.encrypt(artists_plain)
  end

  def artist
    SecureDB.decrypt(artists_secure)
  end
end
