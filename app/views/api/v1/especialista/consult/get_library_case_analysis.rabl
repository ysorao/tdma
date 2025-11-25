object @analisis_casos

attributes :id, :name

node :analysis_description do |library|
  library.specialist_response.analysis_description
end