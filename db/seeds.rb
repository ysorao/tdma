# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'pruebas@heon.com', password: 'pruebasheon2025', password_confirmation: 'pruebasheon2025', name:'administrador', surnames:'telederma', number_document:'77777777', phone:'3123456789', status:1, role:1)

Department.create([
  {id: 1, name: 'Amazonas'},
  {id: 2, name: 'Antioquia'},
  {id: 3, name: 'Arauca'},
  {id: 4, name: 'Archipiélago de San Andrés Providencia y Santa Catalina'},
  {id: 5, name: 'Atlántico'},
  {id: 6, name: 'Bogotá D.C'},
  {id: 7, name: 'Bolívar'},
  {id: 8, name: 'Boyacá'},
  {id: 9, name: 'Caldas'},
  {id: 10, name: 'Caquetá'},
  {id: 11, name: 'Casanare'},
  {id: 12, name: 'Cauca'},
  {id: 13, name: 'Cesar'},
  {id: 14, name: 'Chocó'},
  {id: 15, name: 'Córdoba'},
  {id: 16, name: 'Cundinamarca'},
  {id: 17, name: 'Guainía'},
  {id: 18, name: 'Guaviare'},
  {id: 19, name: 'Huila'},
  {id: 20, name: 'La Guajira'},
  {id: 21, name: 'Magdalena'},
  {id: 22, name: 'Meta'},
  {id: 23, name: 'Nariño'},
  {id: 24, name: 'Norte de Santander'},
  {id: 25, name: 'Putumayo'},
  {id: 26, name: 'Quindio'},
  {id: 27, name: 'Risaralda'},
  {id: 28, name: 'Santander'},
  {id: 29, name: 'Sucre'},
  {id: 30, name: 'Tolima'},
  {id: 31, name: 'Valle del Cauca'},
  {id: 32, name: 'Vaupés'},
  {id: 33, name: 'Vichada'},
])

#DIVIPOLA MUNICIPIOS
csv_text = File.read('/home/rails/teledermaweb/db/DIVIPOLA_Codigos_municipios.csv')
#csv_text = File.read("#{Rails.root}/db/DIVIPOLA_Codigos_municipios.csv")

csv = CSV.parse(csv_text, :headers => true)
csv.each do |raw_row|
  row = raw_row.to_hash
  departamento = Department.find_by_name(row["Nombre Departamento"])
  unless departamento.nil?
    departamento.municipalities.create(name: row["Nombre Municipio"], code: row["Código Municipio"], department_id: departamento.id, code_department: row["Código Departamento"])
  end
end

#ASEGURADORAS
csv_text = File.read('/home/rails/teledermaweb/db/Tabla_codigos_EAPB.csv')
#csv_text = File.read("#{Rails.root}/db/Tabla_codigos_EAPB.csv")

csv = CSV.parse(csv_text, :headers => true)
csv.each do |raw_row|
  row = raw_row.to_hash
  Insurance.create(name: row["Nombre"], code: row["Codigo"])
end

#ENFERMEDADES CIE 10
csv_text = File.read('/home/rails/teledermaweb/db/Tabla_codigosCIE10_CDFLLA.csv')
#csv_text = File.read("#{Rails.root}/db/Tabla_codigosCIE10_CDFLLA.csv")

csv = CSV.parse(csv_text, :headers => true)
csv.each do |raw_row|
  row = raw_row.to_hash
  Disease.create(name: row["Descripcion"], code: row["Codigo"], limited_sex: row["Limitada a un Sexo"], lower_limit_age: row["Limite Inferior de edad"], upper_limit_age: row["Limite Superior de edad"], diagnostic_code: row["Codigo Diagnostico"], oid_dgh: row["Oid Dgh"], type_initial_age: row["Tipo Edad Inicial"], initial_age_value: row["Valor Edad Inicial"], type_final_age: row["Tipo Edad Final"], final_age_value: row["Valor Edad Final"], apply_to_sex: row["Aplica a Sexo"], requires_notification: row["Exige Notificacion"], external_cause: row["Causa Externa"], registration_locked: row["Registro Bloqueado"], diagnosis_resolution_000247: row["Diagnostico Resolucion 000247"])
end

#AREAS DEL CUERPO
csv_text = File.read('/home/rails/teledermaweb/db/Tabla_areas_cuerpo.csv')
#csv_text = File.read("#{Rails.root}/db/Tabla_areas_cuerpo.csv")

csv = CSV.parse(csv_text, :headers => true)
csv.each do |raw_row|
  row = raw_row.to_hash
  BodyArea.create(name: row["Nombre"])
end

#Insurance.connection.execute('CREATE EXTENSION UNACCENT')

#ActiveRecord::Base.connection.execute("ALTER SEQUENCE municipalities_id_seq RESTART WITH 1;")