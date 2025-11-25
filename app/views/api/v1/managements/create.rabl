object @desk

node :status do |x|
  200
end

node :desk do |x|
  attributes :id, :subject, :description, :ticket, :user_id, :status, :device_id, :created_at, :updated_at, :response_ticket, :admin_user_id
end

node :image_user do |x|
  x.image_user.url
end

node :image_admin do |x|
  x.image_admin.url
end

node :message do |x|
  "Se guardo correctamente"
end