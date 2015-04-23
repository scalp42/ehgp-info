require 'helpers/application_helpers'
require 'helpers/database_helpers'

class ApplicationController < Sinatra::Base
  #register Sinatra::ActiveRecordExtension
  helpers ApplicationHelpers
  helpers DatabaseHelpers
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.expand_path('../../public', __FILE__)
end
