require 'rest-client'
require 'uri'

class Album
  attr_accessor :name, :artist, :img_link, :wiki, :id, :track_list

  def initialize(name,artist,img_link,wiki,id,track_list)
    @name = name
    @artist = artist
    @img_link = img_link
    @wiki = wiki
    @id = id
    @track_list = track_list
  end
end


