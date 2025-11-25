object @analisis_caso

attributes :id

node :analysis_description do |library|
  library.specialist_response.analysis_description
end