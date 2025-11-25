ActiveAdmin.register MedicalConsultation do

  permit_params :evolution_time, :unit_measurement, :number_injuries, :evolution_injuries, :blood, :exude, :suppurate, :symptom, :change_symptom, :other_factors_symptom, :aggravating_factors, :personal_history, :family_background, :treatment_received, :applied_substances, :treatment_effects, :diagnostic_impression, :description_physical_examination, :physical_audio, :annex_description, :audio_annex, :image_annex, :date_archived, :status, :patient_id, :patient_information_id, :specialist_id, :doctor_id, :reason_consultation, :current_illness, :created_at, :updated_at
  menu false

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 24-07-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Muestra los campos de la tabla consulta
  index do
    column :id
    column :unit_measurement
    column :number_injuries do |c|
      if c.number_injuries == Consultation::MENOS_DE_CINCO
        'Menos de cinco'
      elsif c.number_injuries == Consultation::CINCO_A_DIEZ
        'Cinco a diez'
      else
        'Mas de diez'
      end
    end
    column :evolution_injuries do |c|
			if c.evolution_injuries == Consultation::ESTABLE
		    'Estable'
		  elsif c.evolution_injuries == Consultation::AUMENTO_TAMAÑO
		    'Aumento de tamaño'
		  elsif c.evolution_injuries == Consultation::CAMBIO_COLOR
		    'Cambia de color'
		  elsif c.evolution_injuries == Consultation::AUMENTO_NUMERO
		    'Aumento de número'
		  elsif c.evolution_injuries == Consultation::PERMANENTES
		    'Permanentes'
		  elsif c.evolution_injuries == Consultation::PROGRESIVAS
		    'Progresivas'
		  else
		  	'Recurrentes'
		  end
    end
    column :blood
    column :exude
    column :suppurate
    column :symptom do |c|
    	if c.symptom == Consultation::PRURITO
        'Prurito'
      elsif c.symptom == Consultation::ARDOR
        'Ardor'
      elsif c.symptom == Consultation::DOLOR
        'Dolor'		
      else
        'Ninguna'
      end
    end
    column :change_symptom do |c|
    	if c.change_symptom == Consultation::SI_EMPEORAN_DIA
        'Si empeoran en el día'
      elsif c.change_symptom == Consultation::SI_EMPEORAN_NOCHE
        'Si empeoran en la noche'		
      else
        'No'
      end
    end
    column :other_factors_symptom
    column :aggravating_factors
    column :personal_history
    column :family_background
    column :treatment_received
    column :applied_substances
    column :treatment_effects
    column :diagnostic_impression
    column :description_physical_examination
    column :physical_audio
    column :annex_description
    column :audio_annex
    column :reason_consultation
    column :current_illness
    column :patient_id do |c|
      c.patient.name
    end
    column :patient_information_id
    column :specialist_id do |c|
      c.specialist.nil? ? 'Sin nombre' : c.specialist.name.to_s + ' ' + c.specialist.surnames.to_s
    end
    column :doctor_id do |c|
      c.doctor.nil? ? 'Sin nombre' : c.doctor.name.to_s + ' ' + c.doctor.surnames.to_s
    end
    column :created_at
    column :updated_at
    actions 
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 24-07-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: que se encarga del editar y nuevo
  form do |f|
    f.inputs 'Consulta médica' do
    	f.input :unit_measurement
      f.input :number_injuries, as: :select, collection: [['Menos de cinco', 1], ['Cinco a diez', 2], ['Mas de diez', 3]]
      f.input :evolution_injuries, as: :select, collection: [['Estable', 1], ['Aumento de tamaño', 2], ['Cambia de color', 3], ['Aumento de número', 4], ['Aumento de número', 5], ['Permanentes', 6], ['Progresivas', 7], ['Recurrentes', 8]]
      f.input :blood, as: :select, collection: [['Si', 'true'], ['No', 'false']]
      f.input :exude, as: :select, collection: [['Si', 'true'], ['No', 'false']]
      f.input :suppurate, as: :select, collection: [['Si', 'true'], ['No', 'false']]
      f.input :symptom
      f.input :change_symptom
      f.input :other_factors_symptom
      f.input :aggravating_factors
      f.input :personal_history
      f.input :family_background
      f.input :treatment_received
      f.input :applied_substances
      f.input :treatment_effects
      f.input :diagnostic_impression
      f.input :description_physical_examination
      f.input :reason_consultation
      f.input :current_illness
      f.input :physical_audio
      f.input :audio_annex
      f.input :patient_id, as: :select, collection: Patient.all.collect {|u| [u.name + ' ' + u.last_name, u.id]}
      f.input :specialist_id, as: :select, collection: User.where(type_professional: User::ESPECIALISTA).collect {|u| [u.name + ' ' + u.surnames, u.id]}
      f.input :doctor_id, as: :select, collection: User.where(type_professional: User::MEDICO).collect {|u| [u.name + ' ' + u.surnames, u.id]}
    end
    f.actions
  end
end
