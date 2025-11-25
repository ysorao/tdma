class SpecialistResponse < ApplicationRecord
  belongs_to :consultation, optional: true
  belongs_to :consultation_control, optional: true
  belongs_to :response, class_name: 'User', foreign_key: 'specialist_id', optional: true
  belongs_to :response_nurse, class_name: 'User', foreign_key: 'nurse_id', optional: true
  has_many :formulas
  has_many :library_specialists
  has_many :mipres_files
  has_many :other_diagnostics
  has_many :request_exams

  validates :specialist_id, presence: true, on: :create
  validates :control_recommended, presence: true, on: :update, unless: :case_analysis?

  def case_analysis?
    (self.case_analysis.nil? || self.analysis_description.nil?) || (!self.case_analysis.nil? || !self.analysis_description.nil?)
  end
end
