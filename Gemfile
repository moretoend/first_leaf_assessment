source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '3.0.6'

gem 'rails', '7.1.3.3'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '1.18.3', require: false
gem 'jbuilder', '~> 2.5'
gem 'pg', '1.5.6'
gem 'puma', '~> 3.11'
gem 'sidekiq', '~> 7.2'
gem 'simplecov', '~> 0.22', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.4'
end

group :test do
  gem 'rspec-rails', '~> 6.1'
  gem 'shoulda-matchers', '~> 6.2'
end
