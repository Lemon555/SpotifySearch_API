# frozen_string_literal: true

# Loads data from Spotify to database
class LoadSongFromSpotify
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :retrieve_search_and_songs_data, lambda { |params|
    if Search.find(params)
      Left(Error.new(:cannot_process, 'Search already exist'))
    else
      Right(input: params, search: Spotify::Search.find(params))
    end
  }

  register :create_search_and_songs, lambda { |params|
    search = Search.create(input: params[:input])
    params[:search].map do |_, track|
      write_song(search, track)
    end
    Right(search)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :retrieve_search_and_songs_data
      step :create_search_and_songs
    end.call(params)
  end

  private_class_method

  def self.write_song(search, track)
    search.add_song(
      search_id:    search.id,
      track_name:   track.track_name,
      link:         track.track_link,
      album:        track.album_name,
      artists:      track.artist_name.to_json,
      images:       track.imgs.to_json
    )
  end
end
