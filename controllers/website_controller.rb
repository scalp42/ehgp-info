require 'controllers/application_controller'

class WebsiteController < ApplicationController
  helpers WebsiteHelpers

  get('/') { slim :home }
  get('/updates') { slim :website_updates }
  get('/test') { binding.pry; 'foo' } if settings.development?
end
