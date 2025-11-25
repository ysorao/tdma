# Modulo para controlar el imei que le pertencece a una IPS
module ProofGlobalModule

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 11-09-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Dependiendo de un imei verificar kit e ips
  def validate_imei(imei, user)
    device = Device.find_by_imei(imei)
    unless device.nil? || user.nil?
      cliente = UserClient.validate_device_user(device, user)
    else
      cliente = nil
    end
  end
end