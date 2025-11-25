class LibrarySpecialist < ApplicationRecord
  belongs_to :formula, optional: true
  belongs_to :specialist_response
  belongs_to :specialist_library, class_name: 'User', foreign_key: 'specialist_id'
end
