require 'pry'

desc 'tag=X.X.X - create and push a new git tag'
task :release do
  fail "Usage: `rake #{ARGV[0]} tag=x.x.x`" if ENV['tag'].nil?
  tag = ENV['tag']
  exec "git tag #{tag} && git push --tags"
end


desc 'deploy to production'
task :deploy do

  ### Config/Setup

  # Host to deploy to
  deploy_to = 'localhost'

  # User to deploy to
  deploy_as = 'deployer'

  # Directory to deploy into, relative to user home
  deploy_into = 'ehgp-info'

  ### end config

  tag = ENV['tag']
  if tag.nil?
    latest_tag = `git tag | head -1`.strip
    print "Tag/Ref to deploy (#{latest_tag}): "
    input = $stdin.gets.strip
    tag = input.empty? ? latest_tag : input
  end

  `git show-ref --quiet #{tag}`
  if $?.exitstatus != 0
    puts "!!!  Tag/Ref `#{tag}` does not exist!"
    exit 1
  end

  puts "---> Tag/Ref: #{tag}"
  remote = `git remote -v | awk '/^origin.*fetch/{print $2}'`.strip
  puts "---> Repo URL: #{remote}"

  require 'sshkit'
  require 'sshkit/dsl'
  on "#{deploy_as}@#{deploy_to}" do |host|
    execute :mkdir, '-p', 'ehgp-info'
    within deploy_into do
      # create base infrastructure
      execute :mkdir, '-p', '{releases,shared/{config,tmp,log,bundle}}'

      # make sure required config files are present
      unless test "[ -f #{deploy_into}/shared/config/database.yml ]"
        puts "Create config file `#{deploy_into}/shared/config/database.yml`"
        exit 1
      end

      # Create or Update Repository
      if test "[ -d #{deploy_into}/repo ]"
        # update repo
        within(:repo) { execute :git, :remote, :update }
      else
        execute :git, :clone, '--mirror', remote, :repo
      end

      # Create the release dir and deploy code
      release = File.join 'releases', Time.now.strftime('%Y-%m-%d_%H-%M-%S')
      execute :mkdir, '-p', release
      execute :git, :archive, '--remote', 'repo', tag, "| tar -xf - -C #{release}"

      # link dirs and files
      within release do
        execute :rm, '-rf', '{tmp,log}'
        execute :ln, '-sf', '../../shared/{tmp,log}', '.'
        execute :ln, '-sf', '../../shared/config/database.yml', 'config/database.yml'
        
        # install bundle
        execute :bundle, :install, *%w(--deployment -j2 --path ../../shared/bundle --without development:test)
      end # within 'release'

      # link the new current
      execute :rm, '-f', :current
      execute :ln, '-sf', release, :current
      
    end # within '#{deploy_into}'

    # restart!
    execute '/etc/init.d/ehgp-szene', 'restart'
  end
end
