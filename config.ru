require 'rubygems'
require 'bundler'
require 'sinatra'
require 'sinatra/twitter-bootstrap'


Bundler.require

require './app'
run MusicSearch
