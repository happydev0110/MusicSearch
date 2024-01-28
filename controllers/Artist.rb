require 'rest-client'
require 'uri'

class Artist
	attr_accessor :name, :mbid, :img_link, :wiki

	def initialize(name,mbid,img_link,wiki)
		@name = name 
		@mbid = mbid
		@img_link = img_link
		@wiki = wiki
	end

end


