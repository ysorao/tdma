# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#

#Se inactiva el contrato y los usuarios del cliente (Finalizacion contrato)
every 1.day, :at => '6:00am' do
  runner "Contract.expire_contract"
end

#Se avisa cuando un contrato esta próximo a vencerse
every 1.day, :at => '6:00am' do
  runner "Contract.near_expire_contract"
end

#Se elimina de forma automatica cada 15 dias los archivos pdf de historias clinicas temporales
every 15.days :at => '6:00am' do
  runner "Client.pdf_temporal_files"
end

#Si el cliente carga creditos disponibles, automaticamente sus consultas pasan a estado pendiente
# y se descuenta credito(s)
every 1.day, :at => '6:00am' do
  runner "Client.discount_credits"
end

# Learn more: http://github.com/javan/whenever