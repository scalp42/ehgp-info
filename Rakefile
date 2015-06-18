require 'pry'

desc 'tag=X.X.X - create and push a new git tag'
task :release do
  tag = ensure_tag
  exec "git tag #{tag} && git push --tags"
end


desc 'deploy to production'
task :deploy do
  tag = ENV['tag']
  if tag.nil?
    latest_tag = `git tag | head -1`.strip
    print "Tag/Ref to deploy (#{latest_tag}): "
    input = $stdin.gets.strip
    tag = input.empty? ? latest_tag : input
  end

  puts "---> Tag/Ref: #{tag}"
  remote = `git remote -v | awk '/^origin.*fetch/{print $2}'`.strip
  puts "---> Repo URL: #{remote}"

  require 'net/ssh'
  SSH = Net::SSH.start('ehgp-info', 'deployer')

  # create base infrastructure
  ssh 'mkdir -pv ehgp-info/{releases,shared/{config,tmp,log,bundle}}'

  # make sure required config files are present
  if SSH.exec!('test -f ehgp-info/shared/config/database.yml && echo -n ok') != 'ok'
    fail 'Create config file `ehgp-info/shared/config/database.yml`'
  end

  # initialize or update the repository
  if SSH.exec!('test -d ehgp-info/repo && echo ok').nil?
    # repo is missing
    ssh "git clone --mirror #{remote} ehgp-info/repo", err: false
  else
    # update repo
    ssh 'cd ehgp-info/repo && git remote update', err: false
  end

  # create release dir
  current = File.join 'releases', Time.now.strftime('%Y-%m-%d_%H-%M-%S')
  ssh "mkdir -pv ehgp-info/#{current}"
  ssh "git archive --remote ehgp-info/repo #{tag} | tar -xf - -C ehgp-info/#{current}"

  # link dirs and files
  ssh "rm -rfv ehgp-info/#{current}/{tmp,log,config/database.yml}"
  ssh "ln -svf ../../shared/{tmp,log} ehgp-info/#{current}/"
  ssh "ln -svf ../../shared/config/database.yml ehgp-info/#{current}/config/"

  # install bundle
  ssh "cd ehgp-info/#{current} && bundle install --deployment -j2 --path ../../shared/bundle --without development:test"

  # link dir
  ssh "rm -fv ehgp-info/current && ln -svf #{current} ehgp-info/current"
end


def ssh(cmd, err: true)
  puts "---> [SSH] #{cmd}"
  SSH.exec!(cmd) do |_,stream,data|
    pre = err && stream.eql?(:stderr) ? '!!! ' : ''
    data.each_line { |line| print "#{pre}#{line}" }
  end
end

def ensure_tag
  fail "Usage: `rake #{ARGV[0]} tag=x.x.x`" if ENV['tag'].nil?
  ENV['tag']
end
