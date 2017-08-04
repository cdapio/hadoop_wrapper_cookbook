source 'https://rubygems.org'

# env var for travis, modeled after chefspec
if ENV['CHEF_VERSION']
  if ENV['CHEF_VERSION'] == 'master'
    gem 'chef', git: 'https://github.com/chef/chef'
  else
    gem 'chef', ENV['CHEF_VERSION']
  end
end

group :test do
  gem 'berkshelf', '~> 4.0'
  gem 'chefspec'
  gem 'foodcritic'
  gem 'rake'
  gem 'rspec'
  gem 'rubocop'
end
