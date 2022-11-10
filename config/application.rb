require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Railsite
  class Application < Rails::Application
    config.data_path = if Rails.env.production?
      # Read the destination from the fly.toml file so we don't have to bother
      # you to set an ENV var.
      if ENV.key? "DATA_PATH"
        Pathname.new ENV["DATA_PATH"]
      elsif File.exist? "fly.toml"
        fly_config = TOML.load_file "fly.toml"
        destination = fly_config.fetch("mounts")&.fetch("destination")
        Pathname.new(destination)
      else
        warn "Could not set config.data_path. Run `fly volume create` or set the DATA_PATH env var. Setting to ./tmp."
        Rails.root.join("tmp")
      end
    else
      # Just use the `./storage` path since it exists.
      Rails.root.join("storage")
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
