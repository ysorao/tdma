namespace :export do
  desc "Exportar historias clínicas a CSV"
  task historia_clinica: :environment do
    require 'csv'
    
    filename = "historias_clinicas_#{Date.today.strftime('%Y%m%d')}.csv"
    filepath = Rails.root.join('public', filename)
    
    # BOM para Excel
    File.write(filepath, "\xEF\xBB\xBF")
    
    CSV.open(filepath, 'a:UTF-8', col_sep: ';') do |csv|
      csv << [
        'ID_Paciente', 'Tipo_Documento', 'Numero_Documento', 'Nombre', 'Segundo_Nombre',
        'Apellido', 'Segundo_Apellido', 'Fecha_Nacimiento', 'Genero',
        'Edad', 'Unidad_Medida_Edad', 'Estado_Civil', 'Ocupacion', 'Telefono', 'Email',
        'Direccion', 'Zona', 'Aseguradora',
        'ID_Consulta', 'Fecha_Consulta', 'Estado_Consulta', 'Medico', 'Enfermera',
        'Sintoma', 'Tiempo_Evolucion', 'Numero_Lesiones', 'Evolucion_Lesiones',
        'Sangra', 'Exuda', 'Supura', 'Cambio_Sintomas', 'Factores_Agravantes',
        'Antecedentes_Personales', 'Antecedentes_Familiares', 'Tratamiento_Recibido',
        'Sustancias_Aplicadas', 'Efectos_Tratamiento', 'Impresion_Diagnostica',
        'Motivo_Consulta', 'Enfermedad_Actual', 'Peso', 'Examen_Fisico',
        'Lesiones_Descripcion', 'Control_Recomendado', 'Analisis_Caso'
      ]
      
      Patient.includes(
        :patient_informations,
        consultations: [:medical_consultation, :injuries, :specialist_responses, :doctor, :nurse]
      ).find_each do |patient|
        patient.consultations.each do |consultation|
          pi = consultation.patient_information || patient.patient_informations.last
          mc = consultation.medical_consultation
          sr = consultation.specialist_responses.last
          
          tipo_doc = case patient.type_document
            when 1 then 'CC'; when 2 then 'CE'; when 3 then 'CD'; when 4 then 'PA'
            when 5 then 'SC'; when 6 then 'PE'; when 7 then 'RE'; when 8 then 'RC'
            when 9 then 'TI'; when 10 then 'CN'; when 11 then 'AS'; when 12 then 'MS'
            else patient.type_document
          end
          
          genero = patient.genre == 1 ? 'Masculino' : 'Femenino'
          
          estado = case consultation.status
            when 1 then 'Resuelto'; when 2 then 'Requerimiento'; when 3 then 'Pendiente'
            when 4 then 'Archivado'; when 5 then 'En Proceso'; when 6 then 'Sin Creditos'
            when 7 then 'Remision'; when 8 then 'Evaluando'
            else consultation.status
          end
          
          unidad_edad = case pi&.unit_measure_age
            when 1 then 'Anios'; when 2 then 'Meses'; when 3 then 'Dias'; else ''
          end
          
          zona = case pi&.urban_zone
            when 1 then 'Urbana'; when 2 then 'Rural'; else ''
          end
          
          lesiones_desc = consultation.injuries.map { |i| "#{i.name}: #{i.description}" }.join(' | ')
          
          csv << [
            patient.id, tipo_doc, patient.number_document, patient.name, patient.second_name,
            patient.last_name, patient.second_surname, patient.birthdate&.strftime('%Y-%m-%d'), genero,
            pi&.age, unidad_edad, pi&.civil_status, pi&.occupation, pi&.phone, pi&.email,
            pi&.address, zona, pi&.insurance&.name,
            consultation.id, consultation.created_at&.strftime('%Y-%m-%d %H:%M'), estado,
            consultation.doctor&.name, consultation.nurse&.name,
            mc&.symptom, mc&.evolution_time, mc&.number_injuries, mc&.evolution_injuries,
            mc&.blood ? 'Si' : 'No', mc&.exude ? 'Si' : 'No', mc&.suppurate ? 'Si' : 'No',
            mc&.change_symptom, mc&.aggravating_factors, mc&.personal_history, mc&.family_background,
            mc&.treatment_received, mc&.applied_substances, mc&.treatment_effects,
            mc&.diagnostic_impression, mc&.reason_consultation, mc&.current_illness, mc&.weight,
            mc&.description_physical_examination, lesiones_desc, sr&.control_recommended, sr&.case_analysis
          ]
        end
      end
    end
    
    puts "Archivo exportado: #{filepath}"
  end

  desc "Exportar solo pacientes a CSV"
  task pacientes: :environment do
    require 'csv'
    
    filename = "pacientes_#{Date.today.strftime('%Y%m%d')}.csv"
    filepath = Rails.root.join('public', filename)
    
    File.write(filepath, "\xEF\xBB\xBF")
    
    CSV.open(filepath, 'a:UTF-8', col_sep: ';') do |csv|
      csv << ['ID', 'Tipo_Doc', 'Numero_Doc', 'Nombre', 'Segundo_Nombre', 
              'Apellido', 'Segundo_Apellido', 'Fecha_Nacimiento', 'Genero',
              'Total_Consultas', 'Fecha_Creacion']
      
      Patient.includes(:consultations).find_each do |p|
        tipo_doc = Patient.name_document(p.type_document)
        genero = p.genre == 1 ? 'M' : 'F'
        csv << [p.id, tipo_doc, p.number_document, p.name, p.second_name,
                p.last_name, p.second_surname, p.birthdate, genero,
                p.consultations.count, p.created_at&.strftime('%Y-%m-%d')]
      end
    end
    
    puts "Archivo exportado: #{filepath}"
  end
end
