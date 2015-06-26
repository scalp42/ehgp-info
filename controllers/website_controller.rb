require 'controllers/application_controller'

class WebsiteController < ApplicationController
  get('/') { slim :home }
  get('/updates') { slim :website_updates }
  get('/test') { binding.pry; 'foo' }
end
