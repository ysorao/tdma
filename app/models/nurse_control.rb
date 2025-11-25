class NurseControl < ApplicationRecord
  belongs_to :consultation_control, optional: true
  belongs_to :consultation, optional: true

  validates :subjetive_improvement, :ulcer_length, :ulcer_width, :pain_intensity, :consultation_control_id, :commentation, presence: true
  validates :tolerated_treatment, inclusion: { in: [ true, false ] }
  validates :improvement, inclusion: { in: [ true, false ] }

  #Permite mostrar los controles que se le han hecho a un paciente
  def self.patient_nurse_control(patient)
    includes(:consultation_control).where("consultation_controls.patient_id = ? AND consultation_controls.status != ?", patient, Consultation::EVALUANDO).references(:consultation_control).order(created_at: :asc)
  end
end
