# Controlador para funcionalidades del cliente IPS
class Clients::ClienteController < ApplicationController

  before_action :authenticate_client_user!, except: [:generate_history_clinic]

  require 'zip'

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-03
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite listar las sedes del cliente
  def subsidiaries
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-03
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Vista del formulario de sedes
  def new_subsidiaries
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-04
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite listar los kits del cliente
  def kits
    kits = Kit.includes(:contract).where("contracts.client_id = ? AND kits.code_verified = ?", current_client_user.client_id, true).references(kit: :contract).order(:created_at)
    additional = AdditionalCard.includes(:contract).where("contracts.client_id = ?", current_client_user.client_id).references(:contract).order(:created_at)
    @kits = kits + additional
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-05
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite listar los profesionales de una IPS
  def professionals
    @professionals = UserClient.where(client_id: current_client_user.client_id)
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-05
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Vista del formulario del profesional
  def new_professional
    @professional = User.new
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-05
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Vista del ver profesional
  def show_professional
    @professional = User.find(params[:id])
  end
    
  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-07
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear un profesional de una IPS
  def create_professional
   @professional = User.new(users_params)
   @professional.commit = 'web'
    if @professional.save
      UserClient.create(user_id: @professional.id, client_id: current_client_user.client_id)
      redirect_to professionals_clients_cliente_index_path, notice: 'Creado correctamente'
    else
      render :new_professional, action: @professional
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-09-19
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite consultar los pacientes del cliente
  def search_patient
    if params[:search].nil?
      @patient = []    
    else
      @patient = Patient.patient_search(params[:search].to_s, current_client_user.client_id)
      consult, control = 0, 0
      #Trazabilidad
      @patient.each do |pat|
        if pat.consultations.count > 0
          consult = 1
        end
        if pat.consultation_controls.count > 0
          control = 1
        end
      end
      if consult == 1
        TraceabilityConsult.create(seach_patient_id: current_client_user.id)
      end 
      if control == 1
        TraceabilityControl.create(seach_patient_id: current_client_user.id)
      end
      TraceabilityClient.create(client_user_id: current_client_user.id)
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-07
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Historia clinica (Generar un script por mes para borrar carpeta pdf_temp_files)
  def generate_history_clinic
    #@paciente = Patient.find(params[:p].to_i)
    #@consulta = Consultation.where(patient_id: params[:p].to_i).where.not(status: [Consultation::EVALUANDO, -1]).order(created_at: :asc)
    @paciente = Patient.includes(:client, :consultations, :consultation_controls, :patient_informations).find(params[:p].to_i)
    @consulta = Consultation.includes(:patient, :patient_information, :specialist, :assistant, :doctor, :nurse, :user_assign, :injuries, :medical_controls, :specialist_responses, :requests, :annex_images, :consultation_controls, :medical_consultation, :nurse_consultation, :payment_histories).where(patient_id: params[:p].to_i).where.not(status: -1).order(created_at: :asc)
    save_path = ""

    respond_to do |format|
      format.html
      format.pdf do
        #pdf_file = render_to_string :pdf => 'Telederma_' +@paciente.name.to_s+ "_" +@paciente.last_name, 
          #:template => 'clients/cliente/generate_history_clinic.pdf.erb', 
          #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf', zoom: '2.5', margin: { top: 5, left: 0, right: 0, bottom: 10 }, footer: { :html => {:template => 'clients/cliente/footer.pdf.erb'}}
        pdf_file = render_to_string(
          pdf: "Telederma_#{@paciente.name}_#{@paciente.last_name}",
          template: "clients/cliente/generate_history_clinic", formats: [:html],
          enable_local_file_access: true,
          zoom: "2.5",
          margin: { top: 5, left: 0, right: 0, bottom: 10 },
          footer: { html: { template: "clients/cliente/footer", formats: [:html] } }
        )

        tempfile = Tempfile.new(['invoice', '.pdf'], Rails.root.join('tmp'))
        tempfile.binmode
        tempfile.write pdf_file
        tempfile.close

        #Permite Ecryptar el documento PDF
        pdf = Origami::PDF.read(tempfile.path).encrypt(cipher: 'aes', key_size: 256, user_passwd: @paciente.number_document, owner_passwd: @paciente.number_document)
        save_path = 'Telederma_' + @paciente.name.to_s+ "_" +@paciente.last_name + '.pdf'
        pdf.save("pdf_temp_files/#{save_path}")
        send_file(Rails.root.join("pdf_temp_files/#{save_path}"))
        tempfile.unlink
      end
    end
    #Trazabilidad
    if current_client_user.nil?
      TraceabilityConsult.create(client_user_id: params[:c], print_clinic_history: true)
      TraceabilityClient.create(client_user_id: params[:c], print_clinic_history: true)
    else
      TraceabilityConsult.create(client_user_id: current_client_user.id, print_clinic_history: true)
      TraceabilityClient.create(client_user_id: current_client_user.id, print_clinic_history: true)
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-08
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Compartir en el correo del paciente su historia clinica
  def send_history_clinic
    patient = PatientInformation.where(patient_id: params[:patient_id]).last
    patient.update_attribute(:email, params[:email])
    if patient.email.nil?
      redirect_to search_patient_clients_cliente_index_path, alert: 'No se pudo compartir ya que no tiene un correo asociado', format: 'js'  
    else
      #Trazabilidad
      TraceabilityConsult.create(client_user_id: current_client_user.id, shared_clinic_history: true)
      TraceabilityClient.create(client_user_id: current_client_user.id, shared_clinic_history: true)
      EmailDocumentation.shared_history_clinic(patient, current_client_user.id).deliver_now
      redirect_to search_patient_clients_cliente_index_path, notice: 'Enviado correctamente', format: 'js' 
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-08
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Vista del formulario del paciente
  def new_patient
    @patient = Patient.new
    @patient.patient_informations.build
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-08
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear un profesional de una IPS
  def create_patient
    @patient = Patient.new(patient_params)
    #@patient.municipio = @patient.patient_informations.last.municipality_id
    @patient.commit = "web"
    @patient.patient_informations[0].urban_zone = params[:urban_zone]
    @patient.birthdate = patient_params[:birthdate]
    @patient.patient_informations[0].terms_conditions = true
    @patient.patient_informations[0].municipality_id = params[:otro]

    params[:insurance_id] = @patient.patient_informations[0].insurance_id

    if @patient.save
      #Trazabilidad
      TraceabilityConsult.create(client_user_id: current_client_user.id)
      TraceabilityClient.create(client_user_id: current_client_user.id, create_patient_id: current_client_user.id)
      redirect_to search_patient_clients_cliente_index_path, notice: 'Paciente creado correctamente'
    else
      render :new_patient
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-09-19
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite mostrar las aseguradoras del cliente
  def insurances
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-24
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: PUT
  #
  # Metodo: Permite actualizar el estado de un profesional
  def update_status
    user = User.find(params[:id])
    user.update_attribute(:status, params[:status])
    redirect_to professionals_clients_cliente_index_path, format: 'js'
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-09-19
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite generar un RIP de acuerdo a una busqueda en especifico
  def generate_rips
    @patient = []
    unless params[:init_date].nil? || params[:end_date].nil?
      ips_insurance = IpsInsurance.where("client_id = ? AND insurance_id IN (SELECT id FROM insurances WHERE name = ?)", current_client_user.client_id, params[:search_eapb]).first

      if ips_insurance.nil?
        aseguradora = nil
      else
        aseguradora = ips_insurance.insurance_id
      end

      #Archivo US
      @patient = Patient.patient_rips(current_client_user.client_id, aseguradora, params[:init_date].to_date, params[:end_date].to_date)
      #Archivo AF
      @bill_insurance = BillsInsurance.where(ips_insurance_id: ips_insurance)

      if @bill_insurance.blank?
        render template: "/clients/cliente/generate_rips.html.erb", locals: {flag: true}
      else
        #Archivo AC
        consultas = MedicalConsultation.consult_medical(current_client_user.client_id, aseguradora, [Consultation::RESUELTO, Consultation::REMISION, Consultation::REQUERIMIENTO])
        controles = MedicalControl.control_medical(current_client_user.client_id, aseguradora, [Consultation::RESUELTO, Consultation::REMISION, Consultation::REQUERIMIENTO])

        @consultation = consultas + controles

        file = "CT#{Date.today.strftime('%m%Y')}.txt"
        File.open(file, "w"){ |f| f << Client.to_csv(current_client_user.client_id, (consultas.count + controles.count), @patient.count) }

        file2 = "US#{Date.today.strftime('%m%Y')}.txt"
        File.open(file2, "w"){ |f| f << @patient.to_csv }

        file3 = "AF#{Date.today.strftime('%m%Y')}.txt"
        File.open(file3, "w"){ |f| f << @bill_insurance.to_csv }

        file4 = "AC#{Date.today.strftime('%m%Y')}.txt"
        unless ips_insurance.nil?
          File.open(file4, "w"){ |f| f << MedicalConsultation.to_csv(@consultation, ips_insurance) }
        else
          File.open(file4, "w"){ |f| f << nil }
        end

        filename = 'rips.zip'
        temp_file = Tempfile.new(filename)
        input_filenames = [file, file2, file3, file4]

        begin
          #Initialize the temp file as a zip file
          Zip::OutputStream.open(temp_file) { |zos| }
         
          #Add files to the zip file as usual
          Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
            input_filenames.each do |filename|
              zipfile.add(filename, File.join(filename))
            end
          end
         
          #Read the binary data from the file
          zip_data = File.read(temp_file.path)
         
          #Trazabilidad
          #TraceabilityClient.create(client_user_id: current_client_user.id, insurance_id: aseguradora, init_date: params[:init_date].to_datetime, end_date: params[:end_date].to_datetime)

          #Send the data to the browser as an attachment
          #We do not send the file directly because it will
          #get deleted before rails actually starts sending it
          send_data(zip_data, :type => 'application/zip', :filename => filename)
        ensure
          #Close and delete the temp file
          temp_file.close
          temp_file.unlink
        end
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-11-03
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite mostrar las facturas generadas por aseguradora del cliente
  def bills_insurances
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-05-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite listar los usuarios auxiliares
  def users
    @users = ClientUser.where(client_id: current_client_user.client_id, role: ClientUser::AUXILIAR)
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-05-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Vista del formulario de sedes
  def new_user
    @user = ClientUser.new
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-05-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear un usuario auxiliar de una IPS
  def create_user
   @user = ClientUser.new(client_user_params)
   @user.commit = 'web'
   @user.client_id = current_client_user.client_id
   @user.password = @user.number_document.to_s + 'aA'
   @user.password_confirmation = @user.number_document.to_s + 'aA'
   @user.type_professional = current_client_user.type_professional
   if @user.save
     @user.send_reset_password_instructions
     redirect_to users_clients_cliente_index_path, notice: 'Creado correctamente'
   else
     render :new_user, action: @user
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-05-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: PUT
  #
  # Metodo: Permite actualizar el estado de un usuario auxiliar
  def update_user_status
    user = ClientUser.find(params[:id])
    user.update_attribute(:status, params[:status])
    redirect_to users_clients_cliente_index_path, format: 'js'
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-05-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: PUT
  #
  # Metodo: Permite eliminar un usuario auxiliar
  def destroy
    user = ClientUser.find(params[:id])
    if user.destroy
      redirect_to users_clients_cliente_index_path, format: 'js'
    else
      render :users
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-08-15
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Vista editar
  def edit
    @profile = ClientUser.find(params[:id]) 
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-08-15
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite editar perfil del usuario del cliente
  def update
    @profile = ClientUser.find(profile_params[:id])
    
    if @profile.update(profile_params)
      redirect_to edit_clients_cliente_path(current_client_user.id), notice: 'Editado correctamente'
    else
      render :edit
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-10-08
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Manuales y documentos del sistema
  def system_manuals
    @documents = SystemManual.where(type_manual: SystemManual::IPS)
  end


  private

  def users_params
    params.require(:user).permit(:id, :name, :surnames, :number_document, :type_professional, :professional_card, :phone, :email, :password, :password_confirmation, :commit)
  end

  # Metodo: Especifica los parametros fuertes de la tabla paciente
  def patient_params
    params.require(:patient).permit(:id, :type_document, :type_condition, :number_document, :name, :second_name, :last_name, :second_surname, :birthdate, :genre, :number_inpec, :client_id, :commit, :municipio, patient_informations_attributes: [:id, :terms_conditions, :unit_measure_age, :age, :civil_status, :phone, :occupation, :email, :address, :municipality_id, :urban_zone, :companion, :name_companion, :phone_companion, :responsible, :name_responsible, :phone_responsible, :relationship, :type_user, :authorization_number, :purpose_consultation, :external_cause, :insurance_id, :patient_id, :number_inpec])
  end

  def client_user_params
    params.require(:client_user).permit(:id, :email, :number_document, :professional_card, :name, :surnames, :phone, :commit)  
  end

  def profile_params
    params.require(:client_user).permit(:id, :photo, :name, :surnames, :number_document, :professional_card, :phone, :email, :password, :password_confirmation, :photo_cache)
  end

  # Metodo: Especifica los parametros fuertes de la tabla paciente informacion
  #def patient_information_params
    #params.require(:patient_information).permit(:id, :terms_conditions, :unit_measure_age, :age, :civil_status, :phone, :occupation, :email, :address, :municipality_id, :urban_zone, :companion, :name_companion, :phone_companion, :responsible, :name_responsible, :phone_responsible, :relationship, :type_user, :authorization_number, :purpose_consultation, :external_cause, :insurance_id, :patient_id)
  #end
end