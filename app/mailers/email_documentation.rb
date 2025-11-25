class EmailDocumentation < ApplicationMailer

	layout 'layouts/mailer'

  # Autor: Orlando Guzman Londoño
	#
	# Fecha creacion: 13-07-2018
	#
	# Autor actualizacion:
	#
	# Fecha actualizacion:
	#
	# Metodo: Enviar al correo las consultas del paciente
	def patient_consults(consulta, email)
	  @object = consulta
	  mail(to: email, subject: "Consultas" )
	end

	# Autor: Orlando Guzman Londoño
	#
	# Fecha creacion: 13-07-2018
	#
	# Autor actualizacion:
	#
	# Fecha actualizacion:
	#
	# Metodo: Enviar al correo la formula del paciente
	def formula_patient(patient)
	  @object = patient
	  mail(to: patient.email, subject: "Formula del medicamento" )
	end

	# Autor: Orlando Guzman Londoño
	#
	# Fecha creacion: 13-07-2018
	#
	# Autor actualizacion:
	#
	# Fecha actualizacion:
	#
	# Metodo: Enviar un correo con la prescripción al paciente
	def mipres_consult(patient)
	  @object = patient
	  mail(to: patient.email, subject: "Prescripción de medicamento" )
	end

    # Autor: Orlando Guzman Londoño
	#
	# Fecha creacion: 11-08-2018
	#
	# Autor actualizacion:
	#
	# Fecha actualizacion:
	#
	# Metodo: Enviar un correo al especialista para que descargue el certificado
	def certificate_doctor(user)
      @object = user
	  mail(to: user.email, subject: "Certificación Telederma" )
	end

    # Autor: Orlando Guzman Londoño
	#
	# Fecha creacion: 13-06-2019
	#
	# Autor actualizacion:
	#
	# Fecha actualizacion: 
	#
	# Metodo: Enviar un correo al usuario que solicito la mesa de ayuda
	def help_desk(desk, imei)
      @desk = desk
      @imei = imei
	  mail(to: 'teledermadev@gmail.com', subject: "Soporte tecnico" )
	end

	# Autor: Orlando Guzman Londoño
	#
	# Fecha creacion: 11-08-2018
	#
	# Autor actualizacion: Orlando Guzman Londoño
	#
	# Fecha actualizacion: 13-06-2019
	#
	# Metodo: Enviar un correo al usuario que solicito la mesa de ayuda
	def answer_request(desk)
      @desk = desk
	  mail(to: @desk.user.email, subject: "Respuesta mesa de ayuda Telederma" )
	end

	# Autor: Orlando Guzman Londoño
	#
	# Fecha creacion: 11-08-2018
	#
	# Autor actualizacion: Orlando Guzman Londoño
	#
	# Fecha actualizacion: 13-06-2019
	#
	# Metodo: Enviar un correo al usuario que solicito la mesa de ayuda
	def answer_contact(contact)
      @contact = contact
	  mail(to: @contact.email, subject: "Respuesta contacto Telederma" )
	end

	# Autor: Orlando Guzman Londoño
	#
	# Fecha creacion: 20-09-2018
	#
	# Autor actualizacion:
	#
	# Fecha actualizacion:
	#
	# Metodo: Enviar un correo al cliente avisandole que no tiene creditos
	def notice_credits_client(client)
      @object = client
	  mail(to: client.client_users.first.email, subject: "Créditos no disponibles para teledermatología" )
	end

    # Autor: Orlando Guzman Londoño
	#
	# Fecha creacion: 08-10-2018
	#
	# Autor actualizacion:
	#
	# Fecha actualizacion:
	#
	# Metodo: Enviar un correo al paciente para descargar su historia clinica
	def shared_history_clinic(patient, cliente)
      @object = patient
      @client = cliente
	  mail(to: patient.email, subject: "Historia clínica teledermatología" )
	end

	# Autor: Orlando Guzman Londoño
	#
	# Fecha creacion: 11-01-2019
	#
	# Autor actualizacion:
	#
	# Fecha actualizacion:
	#
	# Metodo: Enviar al correo de contacto de ventas
	def sales_contact(contacto)
	  @object = contacto
	  mail(to: "sectelederma@dermatologia.gov.co", subject: "Contacto de ventas")
	end

	# Autor: Orlando Guzman Londoño
	#
	# Fecha creacion: 11-01-2019
	#
	# Autor actualizacion:
	#
	# Fecha actualizacion:
	#
	# Metodo: Enviar al correo para soporte
	def support(contacto)
	  @object = contacto
	  mail(to: "sectelederma@dermatologia.gov.co", subject: "Soporte técnico")
	end

	# Autor: Orlando Guzman Londoño
	#
	# Fecha creacion: 08-04-2019
	#
	# Autor actualizacion:
	#
	# Fecha actualizacion:
	#
	# Metodo: Enviar al correo del cliente cuando se venció un contrato
	def contract_expire(contrato)
	  @object = contrato
	  mail(to: contrato.client.email, subject: "Contrato de Telederma ha expirado" )
	end

	# Autor: Orlando Guzman Londoño
	#
	# Fecha creacion: 08-04-2019
	#
	# Autor actualizacion:
	#
	# Fecha actualizacion:
	#
	# Metodo: Enviar al correo del cliente y el administrador cuando se va a vencer un contrato
	def contract_near_expire(contrato)
	  @object = contrato
	  mail(to: "#{contrato.client.email}, sectelederma@dermatologia.gov.co", subject: "Su contrato con Telederma está próximo a expirar" )
	end
end