#Mostar informacion especialista (WEB)
object @specialist

attributes :id, :professional_card, :name, :surnames

node :name_complete do |user|
  user.name.to_s + ' ' + user.surnames.to_s
end

node :date do |user|
  user.created_at.strftime("%d/%m/%Y %HH:%MM")
end

node :hour do |user|
  user.created_at.strftime("%I:%m %p")
end