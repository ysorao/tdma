class Api::V1::StaticResourcesController < NoSessionApiController

  include ProofGlobalModule

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-23
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Todas las constantes del sistema por tabla
  #
  # URL: /api/v1/static_resources/system_constants.json
  def system_constants
    constantes =  [{type: "type_professional", values: {Medicina: 1, Enfermería: 2, Auxiliar: 3, Especialista: 4}}, 
    	            {type: "status", values: {Inactivo: 0, Activo: 1}},
    	            {type: "type_document", values: {'Cédula de ciudadanía': 1, 'Cédula de extranjería': 2, 'Carné diplomático': 3, 'Pasaporte': 4, 'Salvoconducto': 5, 'Permiso especial de permanencia': 6, 'Residente especial para la paz': 7, 'Registro civil': 8, 'Tarjeta de identidad': 9, 'Certificado de nacido vivo': 10, 'Adulto sin identificar': 11, 'Menor sin identificar': 12}},
    	            {type: "type_condition", values: {'Tercera edad': 1, 'Indígena mayor de edad': 2, 'Habitante calle mayor de edad': 3, 'Habitante calle menor de edad': 4, 'Menor de edad ICBF': 5, 'Indígena menor de edad': 6, 'Menor de edad recién nacido': 7, 'Víctima menor de edad': 8, 'Víctima mayor de edad': 9, 'Población reclusa INPEC': 10}},
    	            {type: "genre", values: {'Masculino': 1, 'Femenino': 2}},
    	            {type: "civil_status", values: {'Soltero(a)': 1, 'Casado(a)': 2, 'Unión libre': 3, 'Viudo(a)': 4, 'Separado(a) o Divorciado(a)': 5}},
    	            {type: "unit_measurement", values: {'Años': 1, 'Meses': 2, 'Días': 3}},
    	            {type: "type_user", values: {Contributivo: 1, Subsidiado: 2, Vinculado: 3, Particular: 4, Otro: 5, 'Víctima régimen contributivo': 6, 'Víctima régimen subsidiado': 7, 'Víctima no asegurado': 8}},
    	            {type: "consultation_purpose", values: {'No aplica': 1, 'Atención parto': 2, 'Atención recién nacido': 3, 'Atención planificación familiar': 4, 'Crecimiento y desarrollo menor diez años': 5, 'Alteraciones del desarrollo joven': 6, 'Alteraciones del embarazo': 7, 'Alteraciones del adulto': 8, 'Alteraciones de agudeza visual': 9, 'Enfermedad profesional': 10}},
    	            {type: "external_cause", values: {'Enfermedad general': 1, 'Accidente de trabajo': 2, 'Accidente de tránsito': 3, 'Accidente rábico': 4, 'Accidente ofídico': 5, 'Otro tipo de accidente': 6, 'Evento catastrófico': 7, 'Lesión por agresión': 8, 'Lesión autoinfligida': 9, 'Sospecha de maltrato físico': 10, 'Sospecha de abuso sexual': 11, 'Sospecha de violencia sexual': 12, 'Sospecha de maltrato emocional': 13, 'Enfermedad laboral': 14, Otra: 15}},
    	            {type: "urban_zone", values: {Urbana: 1, Rural: 2}},
    	            {type: "number_injuries", values: {'Menos de cinco': 1, 'Cinco a diez': 2, 'Más de diez': 3}},
    	            {type: "evolution_injuries", values: {Estable: 1, 'Aumento de tamaño': 2, 'Cambio de color': 3, 'Aumento de número': 4, Permanentes: 5, Progresivas: 6, Recurrentes: 7}},
    	            {type: "status_consultant", values: {Resuelto: 1, Requerimiento: 2, Pendiente: 3, Archivado: 4, Proceso: 5, 'Sin créditos': 6, 'Remisión': 7, Evaluando: 8}},
    	            {type: "symptom", values: {Prurito: 1, Ardor: 2, Dolor: 3, Ninguno: 4}},
    	            {type: "change_symptom", values: {'Si, y empeoran en el día': 1, 'Si, y empeoran en la noche': 2, No: 3}},
                  {type: "tolerate_medications", values: {'Si': 1, 'No': 2, 'No se formularon': 3}},
                  {type: "ulcer_etiology", values: {'Venosa': 1, 'Arterial': 2, 'Diabetes': 3, 'Ulcera por presión': 4, 'Neuropática': 5, 'Otra': 6, 'Sin diagnóstico': 7}},
                  {type: "infection_signs", values: {'Inflamación': 1, 'Olor fétido': 2, 'Exudado purulento': 3, 'Aumento reciente dolor': 4}},
                  {type: "wound_tissue", values: {'Tejido granulación': 1, 'Fibrina': 2, 'Tejido necrótico': 3, 'Hipergranulación': 4, 'Cicatrización completa': 5, 'Costra': 6}},
                  {type: "pulses", values: {'Ausente': 1, 'Débil': 2, 'Normal': 3}},
                  {type: "skin_among_ulcer", values: {'Dermatitis': 1, 'Fibrosis': 2}},
                  {type: "ulcer_handle", values: {'Medidas de compresión': 1, 'Lavado SSN': 2, 'Gasas vaselinadas': 3, 'Colagenasa': 4, 'Aposito': 5, 'Otro': 6}},
                  {type: "reason", values: {'El paciente no regreso': 1, 'El paciente esta sano': 2, 'No fue posible resolver la solicitud': 3}}]	         
    render status: 200, json: {constants: constantes}
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-23
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Traer de cada departamento sus municipios
  #
  # URL: /api/v1/static_resources/departments.json
  def departments
    @departments = Department.all.order(:name) 
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-23
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-09-12
  #
  # Verbo Http: GET
  #
  # Metodo: Muestra la información de las aseguradoras por IPS
  #
  # URL: /api/v1/static_resources/insurances.json
  def insurances
    if request.headers["imei"].blank?
      render status: 411, json: {error: "El imei no puede estar vacío"}
    else
      device = Device.find_by(imei: request.headers["imei"])
      client = Client.validate_kit(device)
      if device.nil?
        render status: 411, json: {error: "No existe el imei"}
      elsif device.kit_id.nil?
        @insurances = []
      else
        ips_insurance = IpsInsurance.where(client_id: client.id).last
        if params[:last_update].blank?
          @insurances = Insurance.includes(:ips_insurances).where("ips_insurances.client_id = ?", client.id).order("ips_insurances.updated_at").references(:ips_insurances)
        else
          if ips_insurance.updated_at.to_datetime > params[:last_update].to_datetime
            @insurances = Insurance.includes(:ips_insurances).where("ips_insurances.client_id = ?", client.id).order("ips_insurances.updated_at").references(:ips_insurances)
          else
            @insurances = [] 
          end
        end
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-27
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Muestra la información de las partes del cuerpo
  #
  # URL: /api/v1/static_resources/body_areas.json
  def body_areas
    @body_areas = BodyArea.all
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-09-05
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Muestra las enfermedades del CIE10
  #
  # URL: /api/v1/static_resources/diseases.json
  def diseases
    @diseases = Disease.all
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 11-10-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Lista los municipios de acuerdo a un departamento
  def get_municipalities
    municipio =  Municipality.where(department_id: params[:department_id]).order(name: :asc)
    render status: 200, json: {municipality: municipio}
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 11-10-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Lista los EAPB de acuerdo a una busqueda
  def get_insurances
    @aseguradoras = Insurance.where("LOWER(name) ILIKE('%#{params[:term].downcase}%')")
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 11-10-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Lista los municipios de acuerdo a un municipio
  def municipalities
    @municipalities = Municipality.all
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 12-10-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Todas la aseguradoras
  def all_insurances
    @all_insurances = Insurance.all
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-11-03
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Lista las aseguradoras de una IPS
  def get_ips_insurances
    @ips_aseguradoras = IpsInsurance.where(client_id: params[:client_id])
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-09-02
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Iniciar sesión amazon
  #
  # URL: /api/v1/static_resources/access.json
  def access
    imei = request.headers["imei"]

    if imei.blank?
      render status: 411, json: {error: "No puede esta vacío"}
    else
      device = Device.find_by_imei(imei)
 
      if device.nil?
        render status: 411, json: {error: "Imei invalido"}
      else
        render status: 200, json: {status: 200, constant: {ACCESS_KEY: ENV['D_ACCESS_KEY'], BUCKET_DIRECTORY: ENV['D_DIRECTORY'], BUCKET_NAME: ENV['D_NAME'], SECRET_KEY: ENV['D_SECRET_KEY']}, message: 'Enviado' }
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-09-02
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Validar si un imei esta registrado en el sistema
  #
  # URL: /api/v1/static_resources/device.json
  def device
    imei = request.headers["imei"]

    if imei.blank?
      render status: 411, json: {error: "No pueden estar vacíos"}
    else
      device = Device.find_by_imei(imei)
 
      if device.nil?
        render status: 411, json: {error: "No existe"}
      else
        render status: 200, json: {status: 200, message: 'Correcto' }
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 10-09-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Lista las enfermedades CIE10
  def get_diseases
    diseases = Disease.where("LOWER(name) ILIKE('%#{params[:term].downcase}%')").pluck(:name)
    render status: 200, json: {disease: diseases}
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-09-02
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Devuelve todas las respuestas prediseñadas por titulo
  def get_designed_responses
    answers = DesignedResponse.where(status: DesignedResponse::ACTIVO, title: params[:title].to_s)
    render status: 200, json: {designed: answers}  
  end
end