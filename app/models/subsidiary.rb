class Subsidiary < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :kit, optional: true
  belongs_to :municipality, optional: true
  has_many :users

  validates :name, :post_code, :address, :phone_one, :identification, :code_sds, :client_id, :email, presence: true, on: :create
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validate :validate_fields?

  #CONSTANTES
    #type_subs
    IPS = 1
    EPS = 2
    PARTICULAR = 3

    def validate_fields?
      if self.type_subs.nil?
        errors.add(:type_subs, "Debe seleccionar uno de la lista.")      
      end

      if self.kit_id.nil?
        errors.add(:kit_id, "Debe seleccionar uno de la lista.")      
      end

      if self.municipality_id.nil?
        errors.add(:municipality_id, "Debe seleccionar uno de la lista.")      
      end
    end
end
