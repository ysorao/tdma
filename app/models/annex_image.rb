class AnnexImage < ApplicationRecord
  belongs_to :consultation, optional: true 
  belongs_to :consultation_control, optional: true

  mount_base64_uploader :annex_url, ImageAnnexConsultantUploader
end
