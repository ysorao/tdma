module ApplicationHelper

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-29
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Lista de estados con sus nombres
  def estado_consulta(status)
    case status
      when 1
        'Resuelto'
      when 2
        'Requerimiento'
      when 3
        'Pendiente'
      when 4
        'Archivado'
      when 5
        'En proceso'
      when 6
        'Sin créditos'
      when 7
        'Remisión'
      else
        'Evaluando'
    end
  end

  # Método: Trae el nombre del usuario que asigna una consulta
  def user_assign(user_id)
    u = User.find(user_id)
    if u.id == current_user.id
      'Yo'
    elsif u.type_professional == User::ESPECIALISTA
      'Especialista'
    elsif u.type_professional == User::ENFERMERA
      'Enfermera'
    else 
      'Administrativo'
    end
  end

  # Método: Permite traer el tipo de profesional
  def type_prof(type)
    if type == 1
      'Médico'
    elsif type == 2
      'Enfermera'
    elsif type == 3
      'Auxiliar'
    else
      'Especialista'
    end
  end

  #Metodo que devuelve los ids dependiendo si es de control o de consulta
  def list_consult(id, clase)
    if clase.name == "Consultation"
      consulta = Consultation.find(id)
      "#{consulta.id.to_s + '-ca'}"
    else
      control = ConsultationControl.find(id)
      "#{control.id.to_s + '-co'}"
    end
  end

  #Metodo que devuelve el estado civil
  def civil_status(info)
    if info.civil_status == 1
      'Soltero(a)'
    elsif info.civil_status == 2
      'Casado(a)'
    elsif info.civil_status == 3
      'Union Libre'
    elsif info.civil_status == 4
      'Viudo'
    else
      'Separado o Divorciado'
    end 
  end

  #Método que devuelve la informacion de la lesion
  def number_injuries(info)
    if info.number_injuries == MedicalConsultation::MENOS_DE_CINCO
      'Menos de cinco'
    elsif info.number_injuries == MedicalConsultation::CINCO_A_DIEZ
      'Cinco a diez'
    else
      'Mas de diez'
    end
  end

  #Metodo que devuelve el síntoma
  def symptom(info)
    sintomas = []
    info.symptom.split(",").each do |number|
      if number == "1"
        sintomas.push('Prurito')
      elsif number == "2"
        sintomas.push('Ardor')
      elsif number == "3"
        sintomas.push('Dolor')
      else
        sintomas.push('Ninguno')
      end
    end
    sintomas.join(", ")
  end

  #Metodo que devuelve la evolucion de las lesiones
  def evolution_injuries(info)
    lesiones = []
    info.evolution_injuries.split(",").each do |number|
      if number == "1"
        lesiones.push('Estable')
      elsif number == "2"
        lesiones.push('Aumento de tamaño')
      elsif number == "3"
        lesiones.push('Cambio de color')
      elsif number == "4"
        lesiones.push('Aumento de número')
      elsif number == "5"
        lesiones.push('Permanentes')
      elsif number == "6"
        lesiones.push('Progresivas')
      else
        lesiones.push('Recurrentes')
      end
    end
    lesiones.join(", ")
  end

  #Metodo que devuelve el cambio del sintoma
  def change_symptom(info)
    if info.change_symptom == MedicalConsultation::SI_EMPEORAN_DIA
      'Si empeoran en el día'
    elsif info.change_symptom == MedicalConsultation::SI_EMPEORAN_NOCHE
      'Si empeoran en la noche'   
    else
      'No'
    end
  end

  #Metodo que devuelve el tipo de requerimiento segun el especialista
  def type_request(request)
    #if request.specialist_request.type_professional == User::DERMATOLOGO
    if request.type_request == 1 
    'No fue posible responder la teleconsulta: Imágenes desenfocadas e insuficientes para el diagnóstico. Por favor repetirlas.'
    elsif request.type_request == 2
      'No fue posible responder la teleconsulta: No hay imágenes con acercamiento de la lesión. Por favor adicionar imágenes con zoom.'
    elsif request.type_request == 3
      'No fue posible responder la teleconsulta: Se requieren imágenes perpendiculares de la lesión. Por favor adicionarlas.'
    elsif request.type_request == 4
      'No fue posible responder la teleconsulta: Examen físico incompleto. Por favor describir mejor el tipo de lesión, distribucción y localización.'
    else
      'Otro'
    end
  end

  #Metodo que devuelve el tipo de remisión
  def type_remission(consult)
    if !consult.doctor_id.nil?
      if consult.type_remission == 1
        'Cuadro clínico complejo para evaluar por teledermatología. Favor remitir el paciente a dermatólogo presencial.'
      elsif consult.type_remission == 2
        'Se requiere valoración por otra especialidad diferente a dermatología. Favor remitir el paciente a la especialidad correspondiente.'
      elsif consult.type_remission == 3
        'Otro'
      end
    #else
      #Consultation.nurse_remission_consult(consult.type_remission)
    end
  end

  #metodo que devuelve si tolero medicamentos
  def tolerated_medications(control)
    if control.medical_control.tolerated_medications == MedicalControl::SÍ
      'Si'
    elsif control.medical_control.tolerated_medications == MedicalControl::NO
      'No'   
    else
      'No se formularon'
    end  
  end

  #Metodo que devuelve el tipo de usuario
  def type_user(info)
    if info.type_user == 1
      'Contributivo'
    elsif info.type_user == 2
      'Subsidiado'
    elsif info.type_user == 3
      'Vinculado'
    elsif info.type_user == 4
      'Particular'
    elsif info.type_user == 5
      'Otro'
    elsif info.type_user == 6
      'Víctima afiliación regimen contributivo'
    elsif info.type_user == 7
      'Víctima afiliación regimen subsidiado'
    else
      'Víctima no asegurado'
    end
  end

  #Metodo que devuelve la causa externa
  def external_cause(info)
    if info.external_cause == 1
      'Enfermedad general'
    elsif info.external_cause == 2
      'Accidente de trabajo'
    elsif info.external_cause == 3
      'Accidente de transito'
    elsif info.external_cause == 4
      'Accidente rábico'
    elsif info.external_cause == 5
      'Accidente ofídico'
    elsif info.external_cause == 6
      'Otro tipo de accidente'
    elsif info.external_cause == 7
      'Evento catastrófico'
    elsif info.external_cause == 8
      'Lesión por agresión'
    elsif info.external_cause == 9
      'Lesión autoinflingida'
    elsif info.external_cause == 10
      'Sospecha de maltrato físico'
    elsif info.external_cause == 11
      'Sospecha de abuso sexual'
    elsif info.external_cause == 12
      'Sospecha de violencia sexual'
    elsif info.external_cause == 13
      'Sospecha de maltrato emocional'
    elsif info.external_cause == 14
      'Enfermedad laboral'
    else
      'Otra'
    end
  end

  #Metodo que devuelve la finalidad de la consulta
  def purpose_consultation(info)
    if info.purpose_consultation == 1
      'No aplica'
    elsif info.purpose_consultation == 2
      'Atención parto'
    elsif info.purpose_consultation == 3
      'Atención recien nacido'
    elsif info.purpose_consultation == 4
      'Atención planificación familiar'
    elsif info.purpose_consultation == 5
      'Crecimiento y desarrollo menor diez años'
    elsif info.purpose_consultation == 6
      'Alteraciones del desarrollo joven'
    elsif info.purpose_consultation == 7
      'Alteraciones del embarazo'
    elsif info.purpose_consultation == 8
      'Alteraciones del adulto'
    elsif info.purpose_consultation == 9
      'Alteraciones de agudeza visual'
    else
      'Enfermedad profesional'
    end
  end

  #Metodo que permite devolver la unidad de medidas de la edad
  def unit_measure_age(age)
    if age == PatientInformation::AÑOS
      'Años'
    elsif age == PatientInformation::MESES
      'Meses'
    else
      'Días'
    end
  end

  #Metodo que devuelve el tipo de diagnostico
  def type_diagnostic(info)
    if info.type_diagnostic == 1
      'Impresión diagnóstica'
    elsif info.type_diagnostic == 2
      'Confirmado nuevo'
    else
      'Confirmado repetido'
    end
  end

  #Tipos de documento
  def type_document(info)
    if info.type_document == 1
      'Cédula de ciudadania'
    elsif info.type_document == 2
      'Cédula de extranjería'
    elsif info.type_document == 3
      'Carné diplomatico'
    elsif info.type_document == 4
      'Pasaporte'
    elsif info.type_document == 5
      'Salvoconducto'
    elsif info.type_document == 6
      'Permiso especial de permanencia'
    elsif info.type_document == 7
      'Residencia especial para la paz'
    elsif info.type_document == 8
      'Registro civil'
    elsif info.type_document == 9
      'Tarjeta de identidad'
    elsif info.type_document == 10
      'Certificado de nacido vivo'
    elsif info.type_document == 11
      'Adulto sin identificar'
    else
      'Menor sin identificar'
    end 
  end

  #Metodo que permite mostrar la informacion del diagnostico para especialista
  def diagnostic_consult(consult)
    SpecialistResponse.find_by(consultation_id: consult)
  end

  #Metodo que permite mostrar la informacion del diagnostico de control para especialista
  def diagnostic_control(control)
    cont = SpecialistResponse.find_by(consultation_control_id: control)
    cont.nil? ? '' : cont.other_diagnostics
  end

  #Metodo que permite mostrar el diagnostico
  def diagnostic_date(consult)
    diag = OtherDiagnostic.includes(:specialist_response).where("specialist_responses.consultation_id = ?", consult).references(:specialist_response)
    diag.blank? ? 'Ninguno' : diag.first.created_at.strftime("%d/%m/%Y")
  end

  #Para agregar otros campos de aseguradoras en el registro de clientes
  # f is a form object
  def link_to_add_fields(name, f, association)
    # creaate a new object given the form object, and the association name
    new_object = f.object.class.reflect_on_association(association).klass.new

    # call the fields_for function and render the fields_for to a string
    # child index is set to "new_#{association}, which would then later
    # be replaced in in javascript function add_fields
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      # render partial: _task_fields.html.erb
      render("insurances", f: builder)
    end

    # call link_to_function to transform to a HTML link
    # clicking this link will then trigger add_fields javascript function
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\");return false;"), class: 'btn btn-success')
  end

  def link_to_function(name, js, opts={})
    link_to name, '#', opts.merge({onclick: js})
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 19-09-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Generar imagenes dinamicas temporales para ser consultadas desde amazon
  def dynamic_images(imagen, flag, id)
    #Lee las credenciales del recurso
    s3 = Aws::S3::Resource.new(region: ENV['D_REGION'], access_key_id: ENV['D_ACCESS_KEY'], secret_access_key: ENV['D_SECRET_KEY'])

    #Lee el contenido del bucket
    bucket = s3.bucket(ENV['D_NAME'])

    case flag
      when 0
        #Lesiones consulta y control
        unless imagen.photo.blank?
          photo = imagen.photo.split("/").last
          number = id
        end
        if photo.length >= 50
          photo = imagen.photo.split("?").first.split("/").last
          image_s3 = bucket.objects(prefix: "uploads/images_injury/edited_photo/#{number}/#{photo}", delimiter: '').collect(&:key)
        else
          image_s3 = bucket.objects(prefix: "uploads/#{photo}", delimiter: '').collect(&:key)
        end
      when 1
        #Anexos consulta y control
        unless imagen.annex_url.blank?
          photo = imagen.annex_url.split("/").last
        end
        image_s3 = bucket.objects(prefix: "uploads/#{photo}", delimiter: '').collect(&:key)
        #Editar foto lesion consulta y control
      when 2
        unless imagen.edited_photo.blank?
          photo = imagen.edited_photo.url.split("?").first.split("/").last
          number = id
        end
        image_s3 = bucket.objects(prefix: "uploads/images_injury/edited_photo/#{number}/#{photo}", delimiter: '').collect(&:key)
      when 3
        #Foto registro medico
        unless imagen.photo.blank?
          photo = imagen.photo.url.split("/").last
        end
        image_s3 = bucket.objects(prefix: "uploads/user/photo/#{number}/#{photo}", delimiter: '').collect(&:key)
      when 4
        #Firma digital medico
        unless imagen.image_digital.blank?
          photo = imagen.image_digital.url.split("/").last
        end
        image_s3 = bucket.objects(prefix: "uploads/user/image_digital/#{number}/#{photo}", delimiter: '').collect(&:key)
      when 5
        #Lesiones consulta y control PDF
        unless imagen.photo.blank?
          photo = imagen.photo.split("/").last
        end
        image_s3 = bucket.objects(prefix: "reduccion/#{photo}", delimiter: '').collect(&:key)
      when 6
        #Anexos consulta y control PDF
        unless imagen.annex_url.blank?
          photo = imagen.annex_url.split("/").last
        end
        image_s3 = bucket.objects(prefix: "reduccion/#{photo}", delimiter: '').collect(&:key)
      when 7
        #Mesa de ayuda
        unless imagen.image_user.blank?
          photo = imagen.image_user.split("/").last
        end
        image_s3 = bucket.objects(prefix: "uploads/#{photo}", delimiter: '').collect(&:key)
      when 8
        #Documentos del sistema
        unless imagen.file_manual.blank?
          photo = imagen.file_manual.url.split("?")[0].split("/").last
          number = id
        end
        image_s3 = bucket.objects(prefix: "uploads/system_manual/file_manual/#{number}/#{photo}", delimiter: '').collect(&:key)
    end

    #Busqueda de forma especifica por carpeta y archivo
    image_s3.blank? ? amazon_image = '' : amazon_image = image_s3[0].split("/").last

    if photo == amazon_image
      #Generar url dinamica por un tiempo determinado
      bucket.object(image_s3[0]).presigned_url(:get, expires_in: 3600) # 1 minuto
    else
      nil
    end
  end

  #Permite mostrar la imagen reducida en los pdf desde web
  def reduction_image(url_image)
    if url_image.url.blank?
      nil
    else
      b = ''
      a = url_image.url.split("/")

      if (a[3] == 'photo')
        b = "reduccion_#{a[5]}"
      else
        b = "reduccion_#{a[5]}"
      end
      "/#{a[1]}/#{a[2]}/#{a[3]}/#{a[4]}/#{b}"
    end
  end
end
