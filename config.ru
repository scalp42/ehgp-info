require './app.rb'

map(ENV['MOUNT_PATH'] || '/') do
  log = File.expand_path("../log/#{ENV['RACK_ENV']}.log", __FILE__)
  file = File.new(log, 'a+')
  file.sync = true
  use Rack::CommonLogger, file
  run EhgpSzene
end

# vi: syntax=ruby
