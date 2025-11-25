CarrierWave.configure do |config|
  #config.fog_provider = 'fog/aws' 
  #config.fog_credentials = {
  #    :provider               => ENV["D_PROVIDER"],
  #    :aws_access_key_id      => ENV["D_ACCESS_KEY"],
  #    :aws_secret_access_key  => ENV["D_SECRET_KEY"]
  #}
  #config.fog_directory  = ENV["D_NAME"]
  #config.fog_public     = false
  #config.fog_authenticated_url_expiration = 3600
  #config.cache_dir = "#{Rails.root}/tmp/uploads"
end