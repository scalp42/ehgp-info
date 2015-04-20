require './app.rb'

map(ENV['MOUNT_PATH'] || '/') do
  map('/') { run WebsiteController }
end

# vi: syntax=ruby
