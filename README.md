# SpotifySearch Web API
[ ![Codeship Status for Lemon555/SpotifySearch_API](https://codeship.com/projects/1ef7fba0-846f-0134-4b73-22876e02b99f/status?branch=master)](https://codeship.com/projects/183152)

API to search for songs and it's information!

## Routes
* `/` - check if API alive
* `GET /v0.1/:song_name` - search for a specific song and return a array of songs from Database related to the keyword
* `POST /v0.1/:song_name` - retrieve songs from Spotify of the selected keyword related songs and save to Database.

## Try out our api @
`https://spotifysearchapi.herokuapp.com/`
