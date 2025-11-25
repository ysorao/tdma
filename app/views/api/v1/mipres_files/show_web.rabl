#Información del mipres por consulta (WEB)
object @mipres

attributes :id, :specialist_response_id

node :mipres do |mip|
  mip.mipres.nil? ? 'Ninguno' : "http://#{request.host}:#{request.port}" + '' + mip.mipres.url
end