# Ransack 4.x configuration for ActiveAdmin compatibility
# This allows all attributes and associations to be searchable by default
# For production, consider whitelisting specific attributes per model

Ransack.configure do |config|
  # Raise errors in development if ransackable methods are missing
  config.ignore_unknown_conditions = !Rails.env.development?
end

# Add ransackable methods to ApplicationRecord
module RansackableByDefault
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      authorizable_ransackable_attributes
    end

    def ransackable_associations(auth_object = nil)
      authorizable_ransackable_associations
    end
  end
end

# Include in ApplicationRecord after Rails loads
Rails.application.config.after_initialize do
  ApplicationRecord.include(RansackableByDefault) if defined?(ApplicationRecord)
end
