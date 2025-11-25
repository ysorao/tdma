class Formula < ApplicationRecord
  belongs_to :specialist_response, optional: true
  has_many :library_specialists

  validates :generic_name_medicament, :pharmaceutical_form, :drug_concentration, :unit_measure_medication, :number_of_units, :commentations, :specialist_response_id, presence: true


  #Permite traer una formula en especifico
  def self.formula_info(id, consultation_id)
    includes(:specialist_response).where("formulas.id = ? AND specialist_responses.consultation_id = ?", id, consultation_id).references(:specialist_response).first
  end
end
