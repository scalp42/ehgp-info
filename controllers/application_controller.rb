require 'helpers/application_helpers'
require 'helpers/database_helpers'

class ApplicationController < Sinatra::Base
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.expand_path('../../public', __FILE__)

  helpers ApplicationHelpers
  helpers DatabaseHelpers

  configure :production do
    enable :logging
#    log = File.new("#{APP_ROOT}/log/#{settings.environment}.log", 'a+')
#    log.sync = true
#    use Rack::CommonLogger, log
  end
end
