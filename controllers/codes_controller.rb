require 'controllers/application_controller'

class CodesController < ApplicationController
  helpers CodeHelpers

  get ('/codes') do
    slim :codes_index
  end
end
