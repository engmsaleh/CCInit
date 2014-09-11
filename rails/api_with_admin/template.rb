=begin
 The MIT License (MIT)

 Copyright (c) 2014 Cat Cyborg

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
=end

run "rm Gemfile; touch Gemfile"

add_source "https://rubygems.org"
prepend_file 'Gemfile' do <<-FILE
ruby "2.1.1"
FILE
end

append_file '.gitignore' do <<-FILE
.DS_Store
FILE

gem 'rails', '4.0.2'
gem 'rails_12factor'
gem 'pg'
gem 'geocoder'
gem 'newrelic_rpm'

gem 'sinatra', require: false
gem 'slim'
gem 'sidekiq'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem "select2-rails"
gem 'jquery-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem "memcachier"
gem 'kgio'
gem 'rack-cache'
gem 'dalli'

gem 'devise'
gem 'activeadmin', github: 'gregbell/active_admin'

gem 'carrierwave'
gem "fog", "~> 1.3.1"

gem 'jbuilder', '~> 1.2'
gem 'doorkeeper'

gem_group :development, :test do
  gem "rspec-rails"
end

gem_group :development do
  gem "bullet"
  gem "rails-erd"
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

gem 'unicorn' # Use unicorn as the app server
gem "paranoia", "~> 2.0"

# Use debugger
# gem 'debugger', group: [:development, :test]

self_dir = File.expand_path File.dirname(__FILE__)

run "rm README.rdoc"
file "README.md",  ERB.new(File.read File.join(self_dir, 'README.md.erb')).result(binding)

# Copy default routes
prepend_file 'config/routes.rb' do <<-FILE
require 'sidekiq/web'
FILE
end
route File.read(File.join(self_dir, "config", "routes.rb"))

# Copy default configurations
config_path = 'config'
inside config_path do
	run "rm database.yml"
	%w{
		database.yml
		newrelic.yml
	}.each do |file_name|
		file file_name, ERB.new(File.read File.join(self_dir, config_path, file_name + '.erb')).result(binding)
	end
	copy_file File.join(self_dir, config_path, 'unicorn.rb'), 'unicorn.rb'

	append_file 'environment.rb' do <<-FILE

Jbuilder.key_format camelize: :lower
FILE
end
end
copy_file File.join(self_dir, "Procfile"), "Procfile"

# Copy default initializers
Dir[File.join(self_dir, "config", "initializers", "*.erb")].each do |path|
	initializer File.basename(path), ERB.new(File.read path).result(binding)
end
Dir[File.join(self_dir, "config", "initializers", "*.rb")].each do |path|
	initializer File.basename(path), File.read(path)
end

run "bundle install"
generate "rspec:install"
generate "doorkeeper:install"
generate "doorkeeper:migration"
generate "active_admin:install"

