require 'controllers/application_controller'

class WebsiteController < ApplicationController
  helpers WebsiteHelpers

  get('/') { slim :'website/home' }
  get('/updates') { slim :'website/updates' }
  get('/test') { binding.pry; 'foo' } if settings.development?
end
