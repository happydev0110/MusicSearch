require 'rest-client'
require 'uri'

class Track
	attr_accessor :name,:album,:artist,:wiki,:id,:img_link,:duration

	def initialize(name,album,artist,wiki,img_link,duration,id)
		@name = name
		@album = album
		@artist = artist
		@wiki = wiki
		@img_link = img_link
		@id = id
		@duration = duration
	end
end


