class UserClient < ApplicationRecord
  belongs_to :user
  belongs_to :client

  #CONSULTAS
  
  #Permite buscar si un imei le pertenece a un cliente y su contrato esta activo (IPS)
  def self.validate_device_user(device, user)
    device = Device.find(device.id)
  	if device.kit.contract.status == Contract::ACTIVO 
      includes([client: {contracts: [kits: :devices]}]).where("devices.id = ? AND user_clients.user_id = ?", device.id, user.id).references([client: {contracts: [kits: :devices]}]).first  
    else
      nil
    end
  end
end
