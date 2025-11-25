#Lista los tickets por medico (Movil)
object @ticket

attributes :id, :ticket, :subject, :description, :response_ticket, :image_user, :status, :user_id, :device_id, :admin_user_id

node :image_user do |t|
  #dynamic_images(t, 7, nil)
  t.image_user.url
end

node :created_at do |t|
  t.created_at.strftime("%d/%m/%Y %I:%M:%S")
end

node :updated_at do |t|
  t.created_at.strftime("%d/%m/%Y %I:%M:%S")
end

node :image_admin do |t|
  t.image_admin.url
end

