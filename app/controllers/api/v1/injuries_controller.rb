class Api::V1::InjuriesController < ApiController

  require 'image_optimizer'
  respond_to :json


  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2020-08-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear lesion y sus imagenes
  #
  # URL: /api/v1/injuries.json
  def create
    lesion = Injury.new(injuries_params)
    if params[:images].reject(&:empty?).blank?
      render status: 411, json: {error: 'Al menos una imagen es obligatoria'}  
    end
    #Permite identificar si la partes del cuerpo sale error desde el envío en la movil
    if lesion[:body_area_id].to_s >= "183"
      lesion.body_area_id = 182
    end
    
    if lesion.save 
      # params[:images].each do |im|
      #   if im[:image_injury_id].blank?
      #     lesion.images_injuries.create(photo: im[:photo])
      #   else
      #     image_father = ImagesInjury.find_by(photo: im[:image_injury_id])
      #     lesion.images_injuries.create(photo: im[:photo], image_injury_id: image_father.id)
      #   end
      # end
      imagenes = ImagesInjury.where(injury_id: nil).where.not(photo: nil)

      params[:images].each do |im|
        imagenes.each do |x|
          if im[:image_injury_id].blank?
            if im[:photo].split("/").last == x.photo.url.split("/").last
              x.update_attribute(:injury_id, lesion.id)
            end
          else
            derm = im[:image_injury_id].split("/").last
            image_father = ImagesInjury.find_by(photo: derm)
            if im[:photo].split("/").last == x.photo.url.split("/").last
              x.update_attribute(:injury_id, lesion.id)
              x.update_attribute(:image_injury_id, image_father.id)
            end
          end
        end
      end

      if injuries_params[:consultation_id].nil?
        unless lesion.consultation_control.status == Consultation::SIN_CREDITOS
          lesion.consultation_control.update_attribute(:status, Consultation::PENDIENTE)
        end
      else
        unless lesion.consultation.status == Consultation::SIN_CREDITOS
          lesion.consultation.update_attribute(:status, Consultation::PENDIENTE)
        end
      end
      render status: 200, json: {status: 200, injury: lesion, images: lesion.images_injuries.map {|x| x.attributes.except("edited_photo")}, message: "Se guardo correctamente"}
    else
      render status: 411, json: {error: lesion.errors} 
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2020-08-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Imagenes de la lesión
  #
  # URL: /api/v1/injuries/individual_image.json
  def individual_image  
    if params[:annex_url].blank?
      imagen = ImagesInjury.create
      
      if imagen.update_attribute(:photo, params[:photo])
        im = ImagesInjury.find(imagen.id).photo
        ruta = im.root.to_s + '/' + im.store_dir + '/' + "reduccion_#{File.basename(im.path)}"
        FileUtils.cp im.path, ruta
        ImageOptimizer.new(ruta, quality: 25).optimize
        render status: 200, json: {status: 200, image: "http://#{request.host}:#{request.port}" + '' + imagen.photo.url, message: "Se guardo correctamente"}
      else
        render status: 411, json: {error: imagen.errors} 
      end
    else
      annex = AnnexImage.create
    
      if annex.update_attribute(:annex_url, params[:annex_url])
        im = AnnexImage.find(annex.id).annex_url
        ruta = im.root.to_s + '/' + im.store_dir + '/' + "reduccion_#{File.basename(im.path)}"
        FileUtils.cp im.path, ruta
        ImageOptimizer.new(ruta, quality: 25).optimize
        render status: 200, json: {status: 200, image: "http://#{request.host}:#{request.port}" + '' + annex.annex_url.url, message: "Se guardo correctamente"}
      else
        render status: 411, json: {error: annex.errors} 
      end
    end
  end

  private

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-21
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Especifica los parametros fuertes de la tabla lesiones y sus imagenes
  def injuries_params
    params.require(:injury).permit(:id, :consultation_id, :body_area_id, :consultation_control_id)
  end

  def images_params
    params.require(:images_injury).permit(:id, :photo, :injury_id)
  end
end