class CreateInjuriesWorker
  include Sidekiq::Worker

  def perform(lesion, images)
  	lesion = Injury.find(lesion)
    images.each do |im| 
      lesion.images_injuries.create(photo: im)
    end
    lesion.consultation.update_attribute(:status, Consultation::PENDIENTE)
  end
end