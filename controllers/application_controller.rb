require 'helpers/application_helpers'
require 'helpers/database_helpers'

class ApplicationController < Sinatra::Base
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.expand_path('../../public', __FILE__)
  # load or generate session secret
  set :session_secret, ->{
    file = File.join(APP_ROOT, "tmp/.#{settings.environment}-session.store")
    return open(file).read if File.exist?(file)

    # generate new secret
    secret = SecureRandom.hex(64)
    File.open(file, 'w') do |f|
      f.write(secret)
    end
    secret
  }
  enable :sessions

  helpers ApplicationHelpers
  helpers DatabaseHelpers


  configure :production do
    enable :logging
  end

  protected

  # `pass`, falls der gesuchte Kanton nicht existiert
  def check_kanton(kanton)
    pass unless Mandant.kantone.include?(kanton)
  end
end
