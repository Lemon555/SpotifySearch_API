# frozen_string_literal: true

# Search query for songs by optional keywords
class SongsQuery
  def self.call(search)
    search.songs
  end
end
