require './app.rb'

map(ENV['MOUNT_PATH'] || '/') do
  run EhgpSzene
end

# vi: syntax=ruby
