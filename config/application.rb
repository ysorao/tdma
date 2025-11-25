require_relative 'boot'

require 'rails/all'

require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Telederma
  class Application < Rails::Application

  	# Evita error de llamado de libreria de carrierwave para subida de imagenes
    require 'carrierwave'
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Se Configura la arquitectura DDD(Domain Driven Design)
    config.autoload_paths += %W(#{config.root}/lib/modules)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    #config.time_zone = 'America/Bogota' Le resta 5 horas
    config.time_zone = 'Bogota'
    config.active_record.default_timezone = :local

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end
  end
end
