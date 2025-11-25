class PatientConsultsWorker
  include Sidekiq::Worker

  def perform(ids)
    consulta = Consultation.where(id: ids)
    emails = []
    consulta.each do |consul|
      emails.push(consul.patient_information.email)  
    end
    EmailDocumentation.patient_consults(consulta, emails).deliver_now
  end
end