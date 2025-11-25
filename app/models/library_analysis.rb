class LibraryAnalysis < ApplicationRecord
  belongs_to :specialist_response, optional: true

  #Tipos
  LESION = 1
  CASO = 2

  #Permite traer todos los analisis de lesion de una consulta o control del espcialista
  def self.injury_analysis(user)
    includes(:specialist_response).where("specialist_responses.specialist_id = ? AND library_analyses.type_analysis = ?", user, 1).where.not("specialist_responses.case_analysis = ?", "").references(:specialist_response)
  end

  #Permite traer todos los analisis de caso de una consulta o control del espcialista
  def self.case_analysis(user)
    includes(:specialist_response).where("specialist_responses.specialist_id = ? AND library_analyses.type_analysis = ?", user, 2).where.not("specialist_responses.analysis_description = ?", "").references(:specialist_response)
  end
end
