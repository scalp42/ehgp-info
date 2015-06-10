require 'bundler'
Bundler.require
require 'logger'

APP_ROOT = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift File.join(APP_ROOT, 'lib')
require 'core_ext/string'

$LOAD_PATH.unshift APP_ROOT
Dir.glob("#{APP_ROOT}/{helpers,models,controllers}/*.rb").each { |file| require file }

ApplicationController.configure do
  dbc = open("#{APP_ROOT}/config/database.yml").read
  DB = Sequel.connect(YAML.load(dbc)[settings.environment.to_s])
  DB.run('ALTER SESSION SET CURRENT_SCHEMA = KOGU')
end

ApplicationController.configure :development do
  DB.logger = Logger.new($stdout)
end


class EhgpSzene < Sinatra::Base

  use WebsiteController
  use FakturaController
  use CodesController
  use ReferenztarifeController

  configure :development do
    Bundler.require(:development)
    Slim::Engine.set_options pretty: true, sort_attrs: false
  end
end
