object @user

node :status do |x|
  200
end

node :user do |x|
  attributes :id, :email, :number_document, :type_professional, :professional_card, :name, :surnames, :phone, :terms_and_conditions, :status, :digital_signature, :tutorial, :authentication_token, :created_at, :assign_id
end

  node :photo do |x|
    #dynamic_images(x, 3, x.id)
    x.photo.url
  end

  node :image_digital do |x|
    #dynamic_images(x, 4, x.id)
    "http://#{request.host}:#{request.port}" + '' + x.image_digital.url
  end

node :message do |x|
  "Excelente, gracias por registraste!"
end

