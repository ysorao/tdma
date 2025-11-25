object @analisis_lesiones

attributes :id, :name

node :case_analysis do |library|
  library.specialist_response.case_analysis
end