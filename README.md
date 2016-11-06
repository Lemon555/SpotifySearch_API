# SpotifySearch Web API
[ ![Codeship Status for Lemon555/SpotifySearch_API](https://codeship.com/projects/1ef7fba0-846f-0134-4b73-22876e02b99f/status?branch=master)](https://codeship.com/projects/183152)

API to search for songs and it's information!

## Routes
* `/` - check if API alive
* `/v0.1/tracks/:song_name` - search for a specific song and return a hash of track ID from Spotify
* `/v0.1/artists/:song_name` - search for a list of artists of related songs
* `/v0.1/albums/:song_name` - search for a list of albums of related songs
* `/v0.1/links/:song_name` - return a list of links of related songs
* `/v0.1/images/:song_name` - return for a list of images each in 3 sizes of related songs

## Try out our api @
`https://spotifysearchapi.herokuapp.com/`
