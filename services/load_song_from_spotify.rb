# frozen_string_literal: true

# Loads data from Spotify to database
class LoadSongFromSpotify
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :retrieve_search_and_songs_data, lambda { |params|
    if Search.find(input: params)
      Left(Error.new(:already_exist, 'Search already exist'))
    else
      Right(input: params, search: Spotify::Search.find(params))
    end
  }

  register :create_search_and_songs, lambda { |params|
    if params[:search].length.positive?
      search = Search.create(input: params[:input])
      params[:search].map do |key, track|
        write_song(search, key, track)
      end
      Right(search)
    else
      Left(Error.new(:not_found_on_Spotify,
                     "#{params[:input]} not found on Spotify"))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :retrieve_search_and_songs_data
      step :create_search_and_songs
    end.call(params)
  end

  private_class_method

  def self.write_song(search, key, track)
    search.add_song(
      search_id:    search.id,
      track_name:   track.track_name,
      track_id:     key,
      link:         track.track_link,
      album:        track.album_name,
      artists:      track.artist_name.to_json,
      images:       track.imgs.to_json
    )
  end
end
