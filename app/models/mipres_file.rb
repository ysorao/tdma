class MipresFile < ApplicationRecord
  belongs_to :specialist_response, optional: true

  # Archivos carrierwave
  mount_uploader :mipres, MipressUploader

  #Permite traer una preescripcion en especifico
  def self.mipres_info(id, consultation_id)
    includes(:specialist_response).where("mipres_files.id = ? AND specialist_responses.consultation_id = ?", id, consultation_id).references(:specialist_response).first
  end
  
end
