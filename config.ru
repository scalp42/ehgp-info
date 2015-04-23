require './app.rb'

map(ENV['MOUNT_PATH'] || '/') do
  map('/') { run WebsiteController }
  map('/faktura') { run FakturaController }
end

# vi: syntax=ruby
