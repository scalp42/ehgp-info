require 'controllers/application_controller'

class WebsiteController < ApplicationController
  get ('/') { slim :home }
  get ('/test') { binding.pry; 'foo' }
end
