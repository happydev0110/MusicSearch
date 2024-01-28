require 'rest-client'
require 'uri'

class Api
	@api_link = 'http://ws.audioscrobbler.com/2.0/?'
	@api_key= '0ec22e6fe858f16002cec5f6bfe151ae'
	@format = 'json'
	@limit = 4

	def self.search_artist(search_key)
		url = URI.encode(@api_link + 'method=artist.search&artist='+ search_key + '&api_key='+ @api_key + '&limit='+@limit.to_s+'&format='+@format)
		response = RestClient::Request.execute(:method => :get,:url => url,)
    artist_result = JSON.parse(response)
    total_results = artist_result["results"]["opensearch:totalResults"].to_i
    artists = []

    if total_results != 0 
    artists = artist_result["results"]["artistmatches"]["artist"].collect do |x|
      artist_temp = Artist.new(x["name"],x["mbid"],x["image"][2]["#text"],"")
      #artists.push(artist_temp)
      end
    end
    return artists
  end


  def self.search_album(search_key)
    url = URI.encode(@api_link + 'method=album.search&album='+ search_key + '&api_key='+ @api_key + '&limit='+@limit.to_s+'&format='+@format)
    response = RestClient::Request.execute(:method => :get,:url => url,)
    album_result = JSON.parse(response)
    total_results = album_result["results"]["opensearch:totalResults"].to_i
    results = []

    if total_results != 0 
      results = album_result["results"]["albummatches"]["album"].collect do |x|
        album_temp = Album.new(x["name"],x["artist"],x["image"][2]["#text"],"","","")
        #results.push(album_temp)
      end
    end
    return results
  end

  def self.search_track(search_key)
    url = URI.encode(@api_link + 'method=track.search&track='+ search_key + '&api_key='+ @api_key + '&limit='+@limit.to_s+'&format='+@format)
    response = RestClient::Request.execute(:method => :get,:url => url,)
    track_result = JSON.parse(response)
    total_results = track_result["results"]["opensearch:totalResults"].to_i
    results = []

    if total_results != 0 
      results = track_result["results"]["trackmatches"]["track"].collect do |x|
      img_link = x["image"].nil? ? "" : x["image"][2]["#text"]
      track_temp = Track.new(x["name"],"",x["artist"],"",img_link,"","")
      #results.push(track_temp)
      end
    end
    return results
  end

  def self.artist_info(mbid)
    url = URI.encode(@api_link+'method=artist.getinfo&mbid='+ mbid +'&api_key='+@api_key+'&format='+@format)
    response = RestClient::Request.execute(:method => :get,:url => url,)
    artist_info = JSON.parse(response)
    artist = Artist.new(artist_info["artist"]["name"],"",artist_info["artist"]["image"][4]["#text"],artist_info["artist"]["bio"]["summary"])
    return artist
  end


  def self.album_info(album_name,artist_name,id)
    url = URI.encode(@api_link+'method=album.getinfo&artist='+ artist_name + '&album='+ album_name+'&api_key='+@api_key+'&format='+@format)
    response = RestClient::Request.execute(:method => :get,:url => url,)
    album_info = JSON.parse(response)

    tracks_info = []
    if !album_info["album"]["tracks"]["track"].nil? 
      album_info["album"]["tracks"]["track"].each{ |x| 
        track = Track.new(x["name"],"",artist_name,"","",x["duration"].to_i,"")
        tracks_info.push(track)
      }
    end 

    album = Album.new(album_info["album"]["name"],album_info["album"]["artist"],album_info["album"]["image"][3]["#text"],album_info["album"]["wiki"].nil? ? "": album_info["album"]["wiki"]["summary"],"",tracks_info)
    return album
  end



  def self.track_info(track_name,artist_name,id)
    url = URI.encode(@api_link+'method=track.getinfo&artist='+ artist_name + '&track='+ track_name+'&api_key='+@api_key+'&format='+@format)
    response = RestClient::Request.execute(:method => :get,:url => url,)
    track_info = JSON.parse(response)

    t_album = track_info["track"]["album"].nil? ? "" : track_info["track"]["album"]["title"]
    t_summary = track_info["track"]["wiki"].nil? ? "" : track_info["track"]["wiki"]["summary"]
    t_img_link = track_info["track"]["album"].nil? ? "" : track_info["track"]["album"]["image"][3]["#text"]

    track = Track.new(track_info["track"]["name"],t_album,track_info["track"]["artist"]["name"],t_summary,t_img_link,"","")
    return track
  end


end