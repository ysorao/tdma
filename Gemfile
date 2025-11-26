source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '3.1.6'
gem 'rails', '~> 7.1.5'
gem 'concurrent-ruby', '~> 1.2.0'
gem 'pg', '~> 1.4'
gem 'puma', '~> 6.4'
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass', '~> 3.4.1'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'carrierwave', '~> 2.0'
gem 'carrierwave-base64'
gem 'carrierwave-imageoptimizer'
gem 'devise', '~> 4.7'
gem 'simple_token_authentication', '~> 1.0'
gem 'cancancan', '~> 3.0'
gem 'json', '~> 2.0'
gem 'rabl'
gem 'fog-aws', '~> 3.0'
gem 'aws-sdk-s3', '~> 1.0'
gem 'wicked_pdf', '~> 2.1'
gem 'wkhtmltopdf-binary'
gem 'origami', '~> 2.1'
gem 'activeadmin', '~> 3.2'
gem 'sidekiq', '~> 6.0'
gem 'angularjs-rails'
gem 'font-awesome-rails'
gem 'angularjs-file-upload-rails', '~> 2.4.1'
gem 'kaminari'
gem 'rack-cors'
gem 'rubyzip', '~> 2.3'
gem 'activerecord-session_store', '~> 2.0'
gem 'whenever', require: false
gem 'aes', '~> 0.5.0'
gem 'ruby-hl7'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'ransack'
gem 'sitemap_generator'
gem 'route_translator'
gem 'capistrano', '~> 3.7', '>= 3.7.1'
gem 'capistrano-rails', '~> 1.2'
gem 'capistrano-passenger', '~> 0.2.0'
gem 'capistrano-rbenv', '~> 2.1'
gem 'sshkit-sudo'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sdoc'
  gem 'railroady'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rb-readline'
end

group :development do
  gem 'web-console', '>= 3.3.0'
end

group :production do
  gem 'rails_12factor'
end
gem 'rexml'
gem 'matrix'
