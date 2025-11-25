class ImagesInjury < ApplicationRecord
  belongs_to :injury, optional: true
  belongs_to :medical_control, optional: true
  belongs_to :image_injury, class_name: 'ImagesInjury', foreign_key: 'image_injury_id', optional: true

  validates :edited_photo, presence: true, on: :update

  # Archivos carrierwave
  mount_base64_uploader :photo, PhotoImagesUploader
  mount_base64_uploader :edited_photo, EditedPhotoUploader

  #Permite filtrar las imagenes de lesión de un control
  def self.injury_control(control_id, type)
    includes(injury: :consultation_control).where("images_injuries.image_injury_id IS NULL AND injuries.consultation_control_id = ? AND consultation_controls.type_professional = ?", control_id, type).references(injury: :consultation_control).order(created_at: :asc)
  end

  #Permite filtrar las imagenes de lesión de una consulta
  def self.injury_consult(consult_id, type)
    includes(injury: :consultation).where("images_injuries.image_injury_id IS NULL AND injuries.consultation_id = ? AND consultations.type_profesional = ?", consult_id, type).references(injury: :consultation).order(created_at: :asc)
  end

  #Permite filtrar las imagenes de la lesión de control editadas
  def self.injury_edit_control(control_id, type)
    includes(injury: :consultation_control).where("injuries.consultation_control_id = ? AND consultation_controls.type_professional = ? AND images_injuries.edited_photo != ?", control_id, type, "").references(injury: :consultation_control).order(created_at: :asc)
  end

  #Permite filtrar las imagenes de la lesión de consulta editadas
  def self.injury_edit_consult(consult_id, type)
    includes(injury: :consultation).where("injuries.consultation_id = ? AND consultations.type_profesional = ? AND images_injuries.edited_photo != ?", consult_id, type, "").references(injury: :consultation).order(created_at: :asc)
  end

  #Permite mostrar las imagenes dermatoscopicas de la imagen padre para su posible edición
  def self.images_dermatoscopies(id)
    where(image_injury_id: id)
  end
end
