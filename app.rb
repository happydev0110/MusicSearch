require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/twitter-bootstrap'
require "uri"
require 'json'
require 'rest-client'

#load Api.rb to use Last.fm API
#load Api2.rb to use Spotify API

load "controllers/Api.rb"
load "controllers/Artist.rb"
load "controllers/Album.rb"
load "controllers/Track.rb"

register Sinatra::Twitter::Bootstrap::Assets
use Rack::CommonLogger
enable :inline_templates
set :public_folder, 'views'

get '/' do
	erb:index
end

post '/search/' do
	search_key = params[:search_key] 
	artist_list = Api.search_artist(search_key)
	album_list = Api.search_album(search_key)
	track_list = Api.search_track(search_key)
    erb :index_post, :locals => {:artist_list => artist_list, :album_list => album_list, :track_list => track_list}
end

get '/artist' do
	mbid = params['mbid']
	artist_info = Api.artist_info(mbid)
	artist_albums = Api.search_album(artist_info.name)
	artist_tracks = Api.search_track(artist_info.name)
	erb :artist, :locals => {:artist_info => artist_info, :artist_albums=> artist_albums, :artist_tracks => artist_tracks}
end

get '/album' do
	name = params['name']
	artist = params['artist']
	id = params['id']
	album_info = Api.album_info(name,artist,id)
	erb :album, :locals => {:album_info => album_info}

end

get '/track' do
	track = params['name']
    artist = params['artist']
    id = params['id']  
    track_info = Api.track_info(track,artist,id)
	erb :track, :locals => {:track_info => track_info}
end




