require 'yaml'
require 'bundler'
Bundler.require
require 'logger'

APP_ROOT = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift File.join(APP_ROOT, 'lib')
require 'core_ext/string'

$LOAD_PATH.unshift APP_ROOT
require 'controllers/application_controller.rb'

ApplicationController.configure do
  # Don't cast `number` types to BigDecimal
  OCI8::BindType::Mapping[:number] = OCI8::BindType::Integer

  # Load DB configuration
  dbc = open("#{APP_ROOT}/config/database.yml").read
  DB = Sequel.connect(YAML.load(dbc)[settings.environment.to_s])

  # set up DB logging
  log = $stdout.dup # or do `File.new ...` here
  log.sync = true
  logger = Logger.new(log)
  logger.sev_threshold = Logger::WARN if settings.production?
  DB.logger = logger
  DB.run('ALTER SESSION SET CURRENT_SCHEMA = KOGU')
end

Dir.glob("#{APP_ROOT}/{helpers,models,controllers}/*.rb").each { |file| require file }

class EhgpSzene < Sinatra::Base
  helpers ApplicationHelpers

  use WebsiteController
  use FakturaController
  use CodesController
  use ReferenztarifeController

  not_found do
    slim :'404'
  end

  configure :development do
    Slim::Engine.set_options pretty: true, sort_attrs: false
  end
end
