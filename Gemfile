source 'https://rubygems.org'

# env var for travis, modeled after chefspec
gem 'chef', ENV['CHEF_VERSION'] if ENV['CHEF_VERSION']

group :test do
  gem 'berkshelf', '~> 4.0'
  gem 'chefspec'
  gem 'foodcritic'
  gem 'rake'
  gem 'rspec'
  gem 'rubocop'
end
