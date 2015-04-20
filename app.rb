require 'bundler'
Bundler.require

require './controllers/application_controller.rb'
Dir.glob('./controllers/*.rb').each { |file| require file }

ApplicationController.configure :development do
  Bundler.require(:development)
  Slim::Engine.set_options pretty: true, sort_attrs: false
end
