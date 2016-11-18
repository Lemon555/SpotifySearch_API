# frozen_string_literal: true

# Loads data from Search to database
class FindSong
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_params, lambda { |params|
    search = Search.find(input: params)
    if search
      Right(search)
    else
      Left(Error.new(:not_found, 'Search not found'))
    end
  }

  register :search_songs, lambda { |search|
    songs = SongsQuery.call(search)
    results = SongsSearchResults.new(songs)
    Right(results)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_songs
    end.call(params)
  end
end
