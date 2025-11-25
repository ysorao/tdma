class RequestImage < ApplicationRecord
  belongs_to :request

  # Archivos carrierwave
  mount_base64_uploader :image_request, ImageRequestUploader
end
