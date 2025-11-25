class CreateMedicalControlWorker
  include Sidekiq::Worker

  def perform(control_id, images)
    control = MedicalControl.find(control_id)
    images.each do |im| 
      control.images_injuries.create(photo: im)
    end 
  end
end