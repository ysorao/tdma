require 'aws-sdk'


############# GENERAR URL DINAMICAS TEMPORALES PARA CONSULTAR IMAGENES DE AMAZON ############# 


# Permite cargar las variables de entorno (SERVIDOR)
#env_file = File.join(Rails.root, 'config', 'local_env.yml') #Desarrollo
#variables = YAML.load(File.open(env_file))

#Lee las credenciales del recurso
# s3 = Aws::S3::Resource.new(region: ENV['D_REGION'], access_key_id: ENV['D_ACCESS_KEY'], secret_access_key: ENV['D_SECRET_KEY'])

# #Lee el contenido del bucket
# bucket = s3.bucket(ENV['D_NAME'])

# lesiones = ImagesInjury.where("id IN (?)", 141).pluck(:photo).map{|x| x.split("/").last }

# temp= []
# 
# lesiones.each do |les|
#   #Busqueda de forma especifica por carpeta y archivo
#   b = bucket.objects(prefix: "uploads/"#{les}", delimiter: '').collect(&:key)[0].split("/").last
#   if les == b
#     #Generar url dinamica por un tiempo determinado
#     ruta = bucket.object(obj.key).presigned_url(:get, expires_in: 60)
#     les.update_attribute(photo: ruta)
#   end
# end


#Permite subir al bucket un archivo y es privado (prueba)
#bucket.put_object({key: 'hello.txt', body: 'Hello World!', bucket: 'telederma', content_type: 'text/plain'})


################# BORRADO DE IMAGENES LOCALES ALMACENADAS EN AMAZON S3 ###################


#Lee las credenciales del recurso
  #s3 = Aws::S3::Resource.new(region: ENV['D_REGION'], access_key_id: ENV['D_ACCESS_KEY'], secret_access_key: ENV['D_SECRET_KEY'])

#Lee el contenido del bucket
  #bucket = s3.bucket(ENV['D_NAME'])

#lesiones = ImagesInjury.all.pluck(:photo).map{|x| x.split("/").last } #236
#anexos = AnnexImage.all.pluck(:annex_url).map{|x| x.split("/").last } #14

#a = []
     
#Permite borrar cada archivo en el bucket de Amazon S3
# bucket.objects.each do |obj|
#   lesiones.each do |les|
#     if les == obj.key.split("/").last
#       #a.push(obj.key)
#       objeto = bucket.object(obj.key)
#       objeto.delete
#     end
#   end
# end

#puts "#{bucket.objects.count.inspect}"
#puts "#{a.count}"