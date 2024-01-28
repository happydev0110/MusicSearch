require 'rest-client'
require 'uri'
# load "Artist.rb"
# load "Album.rb"
# load "Track.rb"

class Api
	@api_link = 'https://api.spotify.com/v1/'
	@api_key= '0ec22e6fe858f16002cec5f6bfe151ae'
	@format = 'json'
	@limit = 4

	def self.search_artist(search_key)
		url = URI.encode(@api_link + 'search?q='+ search_key + '&type=artist&limit='+@limit.to_s)
		response = RestClient::Request.execute(:method => :get,:url => url,)
    artist_result = JSON.parse(response)
    total_results = artist_result["artists"]["items"].length
    artists = []
    
    if total_results != 0 
     artists = artist_result["artists"]["items"].collect do |x|
      img_link = x["images"].length > 0 ?  x["images"][0]["url"] : ""
      artist_temp = Artist.new(x["name"],x["id"],img_link,"")
      #artists.push(artist_temp)
      end
    end
    return artists
    
  end


  def self.search_album(search_key)
    url = URI.encode(@api_link + 'search?q='+ search_key + '&type=album&limit='+@limit.to_s)
    response = RestClient::Request.execute(:method => :get,:url => url,)
    album_result = JSON.parse(response)
    total_results = album_result["albums"]["items"].length
    results = []

      if total_results != 0 
        results =  album_result["albums"]["items"].collect do |x|
        img_link = x["images"].length > 0 ?  x["images"][0]["url"] : ""
        album_temp = Album.new(x["name"],"",img_link,"",x["id"],"")
        #results.push(album_temp)
        end
      end
    return results
  end

  def self.search_track(search_key)
    url = URI.encode(@api_link + 'search?q='+ search_key + '&type=track&limit='+@limit.to_s)
    response = RestClient::Request.execute(:method => :get,:url => url,)
    track_result = JSON.parse(response)
    total_results = track_result["tracks"]["items"].length
    results = []

    if total_results != 0 
      results = track_result["tracks"]["items"].collect do |x|
      img_link = x["album"]["images"].length > 0 ?  x["album"]["images"][0]["url"] : ""
      track_temp = Track.new(x["name"],"",x["artists"][0]["name"],"",img_link,"",x["id"])
      #results.push(track_temp)
    end
    end
    return results
  end

  def self.artist_info(mbid)
    url = URI.encode(@api_link+'artists/'+ mbid)
    response = RestClient::Request.execute(:method => :get,:url => url,)
    artist_info = JSON.parse(response)
    img_link = artist_info["images"].length > 0 ?  artist_info["images"][0]["url"] : ""
    artist = Artist.new(artist_info["name"],"",img_link,"")
    return artist
  end


  def self.album_info(album_name,artist_name,id)
    url = URI.encode(@api_link+'albums/'+ id)
    response = RestClient::Request.execute(:method => :get,:url => url,)
    album_info = JSON.parse(response)
    img_link = album_info["images"].length > 0 ?  album_info["images"][0]["url"] : ""

    url = URI.encode(@api_link+'albums/'+ id+'/tracks')
    response2 = RestClient::Request.execute(:method => :get,:url => url,)
    tracks_obj = JSON.parse(response2)
    

    tracks_info = []
    if tracks_obj["items"].length > 0 
        tracks_obj["items"].each{ |x| 
        track = Track.new(x["name"],"",x["artists"][0]["name"],"","",x["duration_ms"].to_i,x["id"])
        tracks_info.push(track)
      }
    end 

    album = Album.new(album_info["name"],album_info["artists"][0]["name"],img_link,"","",tracks_info)
    return album
  end



  def self.track_info(track_name,artist_name,id)
    url = URI.encode(@api_link+'tracks/'+ id)
    response = RestClient::Request.execute(:method => :get,:url => url,)
    track_info = JSON.parse(response)

    t_album = track_info["album"]["name"].nil? ? "" : track_info["album"]["name"]
    t_img_link = track_info["album"]["images"].length > 0 ? track_info["album"]["images"][0]["url"] : ""

    track = Track.new(track_info["name"],t_album,track_info["artists"][0]["name"],"",t_img_link,"","")
    return track
  end


end