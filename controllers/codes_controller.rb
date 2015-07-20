require 'controllers/application_controller'

class CodesController < ApplicationController
  helpers CodeHelpers

  get ('/codes') do
    slim :'codes/index'
  end
end
