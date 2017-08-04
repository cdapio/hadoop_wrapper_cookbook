source 'https://rubygems.org'

# env var for travis, modeled after chefspec
if ENV['CHEF_VERSION']
  gem 'chef', ENV['CHEF_VERSION']
end

group :test do
  gem 'berkshelf', '~> 4.0'
  gem 'chefspec'
  gem 'foodcritic'
  gem 'rake'
  gem 'rspec'
  gem 'rubocop'
end
