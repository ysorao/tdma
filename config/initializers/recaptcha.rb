Recaptcha.configure do |config|
  config.site_key  = ENV["D_SITE_KEY"]
  config.secret_key = ENV["D_KEY_SECRET"]
end