# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210713040023) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "additional_cards", force: :cascade do |t|
    t.bigint "contract_id"
    t.bigint "client_id"
    t.bigint "prepay_card_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "end_date"
    t.index ["client_id"], name: "index_additional_cards_on_client_id"
    t.index ["contract_id"], name: "index_additional_cards_on_contract_id"
    t.index ["prepay_card_id"], name: "index_additional_cards_on_prepay_card_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.string "name"
    t.string "surnames"
    t.string "number_document"
    t.string "phone"
    t.integer "status"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "annex_images", force: :cascade do |t|
    t.string "annex_url"
    t.bigint "consultation_id"
    t.bigint "consultation_control_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consultation_control_id"], name: "index_annex_images_on_consultation_control_id"
    t.index ["consultation_id"], name: "index_annex_images_on_consultation_id"
  end

  create_table "app_versions", force: :cascade do |t|
    t.string "apk_file"
    t.string "version_movil"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
  end

  create_table "audits", force: :cascade do |t|
    t.text "description"
    t.datetime "date_action"
    t.bigint "user_id"
    t.bigint "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_audits_on_device_id"
    t.index ["user_id"], name: "index_audits_on_user_id"
  end

  create_table "bills", force: :cascade do |t|
    t.string "payment_file"
    t.boolean "enabled_payment"
    t.string "bill_file"
    t.string "code"
    t.datetime "date_expedition"
    t.bigint "contract_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_bills_on_contract_id"
  end

  create_table "bills_insurances", force: :cascade do |t|
    t.bigint "ips_insurance_id"
    t.bigint "client_id"
    t.string "bill_number"
    t.date "bill_expedition_date"
    t.date "init_date"
    t.date "end_date"
    t.string "administrator_entity_code"
    t.string "administrator_entity_name"
    t.string "contract_number"
    t.string "benefits_plan"
    t.string "policy_number"
    t.integer "total_value_shared_payment"
    t.integer "commision_value"
    t.integer "total_value_discounts"
    t.integer "net_to_pay_contract_entity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "value_consultation"
    t.integer "value_moderator_fee"
    t.index ["client_id"], name: "index_bills_insurances_on_client_id"
    t.index ["ips_insurance_id"], name: "index_bills_insurances_on_ips_insurance_id"
  end

  create_table "body_areas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "number_document"
    t.integer "type_professional"
    t.string "professional_card"
    t.string "name"
    t.string "surnames"
    t.string "phone"
    t.boolean "terms_and_conditions", default: false
    t.integer "status", default: 1
    t.string "digital_signature"
    t.string "digital_image"
    t.string "photo"
    t.string "encrypted_password", default: "", null: false
    t.string "authentication_token", limit: 30
    t.bigint "client_id"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["authentication_token"], name: "index_client_users_on_authentication_token", unique: true
    t.index ["client_id"], name: "index_client_users_on_client_id"
    t.index ["confirmation_token"], name: "index_client_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_client_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_client_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_client_users_on_unlock_token", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.integer "status"
    t.integer "available_credits"
    t.string "identification_number"
    t.integer "type_identification"
    t.string "business_name"
    t.string "bill_number"
    t.datetime "bill_expedition_date"
    t.string "administrator_entity_code"
    t.string "administrator_entity_name"
    t.string "benefits_plan"
    t.string "policy_number"
    t.float "total_value_shared_payment"
    t.float "commision_value"
    t.float "total_value_discounts"
    t.float "net_to_pay_contract_entity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "code_service_provider"
    t.string "email"
    t.bigint "municipality_id"
    t.index ["municipality_id"], name: "index_clients_on_municipality_id"
  end

  create_table "consultation_controls", force: :cascade do |t|
    t.integer "type_professional"
    t.bigint "consultation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.integer "specialist_id"
    t.integer "assistant_id"
    t.integer "doctor_id"
    t.integer "nurse_id"
    t.integer "assign_id"
    t.string "recommended_treatment"
    t.string "diagnostic_impression"
    t.integer "type_remission"
    t.text "remission_comments"
    t.bigint "patient_id"
    t.index ["consultation_id"], name: "index_consultation_controls_on_consultation_id"
    t.index ["patient_id"], name: "index_consultation_controls_on_patient_id"
  end

  create_table "consultations", force: :cascade do |t|
    t.text "annex_description"
    t.string "audio_annex"
    t.datetime "date_archived"
    t.integer "status"
    t.bigint "patient_id"
    t.bigint "patient_information_id"
    t.integer "specialist_id"
    t.integer "assistant_id"
    t.integer "doctor_id"
    t.integer "nurse_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "assign_id"
    t.string "recommended_treatment"
    t.integer "type_profesional"
    t.boolean "archived", default: false
    t.string "diagnostic_impression"
    t.integer "type_remission"
    t.text "remission_comments"
    t.index ["assistant_id"], name: "index_consultations_on_assistant_id"
    t.index ["doctor_id"], name: "index_consultations_on_doctor_id"
    t.index ["nurse_id"], name: "index_consultations_on_nurse_id"
    t.index ["patient_id"], name: "index_consultations_on_patient_id"
    t.index ["patient_information_id"], name: "index_consultations_on_patient_information_id"
    t.index ["specialist_id"], name: "index_consultations_on_specialist_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name_complete"
    t.string "email"
    t.string "phone"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type_contact"
    t.string "response_contact"
    t.integer "status"
    t.bigint "admin_user_id"
    t.bigint "designed_response_id"
    t.index ["admin_user_id"], name: "index_contacts_on_admin_user_id"
    t.index ["designed_response_id"], name: "index_contacts_on_designed_response_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.integer "status"
    t.datetime "agreement_date"
    t.string "contract_number"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_init"
    t.date "date_end"
    t.text "observations"
    t.datetime "date_end_addition"
    t.index ["client_id"], name: "index_contracts_on_client_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "designed_responses", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string "imei"
    t.datetime "delivery_date"
    t.bigint "app_version_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "kit_id"
    t.text "observations"
    t.string "cell_brand"
    t.string "system_version"
    t.index ["app_version_id"], name: "index_devices_on_app_version_id"
    t.index ["kit_id"], name: "index_devices_on_kit_id"
  end

  create_table "diseases", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "limited_sex"
    t.string "lower_limit_age"
    t.string "upper_limit_age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "diagnostic_code"
    t.string "oid_dgh"
    t.string "type_initial_age"
    t.string "initial_age_value"
    t.string "type_final_age"
    t.string "final_age_value"
    t.string "apply_to_sex"
    t.string "requires_notification"
    t.string "external_cause"
    t.string "registration_locked"
    t.string "diagnosis_resolution_000247"
  end

  create_table "formulas", force: :cascade do |t|
    t.string "medication_code"
    t.string "type_medicament"
    t.string "generic_name_medicament"
    t.string "pharmaceutical_form"
    t.string "drug_concentration"
    t.string "unit_measure_medication"
    t.string "number_of_units"
    t.string "unit_value_medicament"
    t.string "total_value_medicament"
    t.bigint "specialist_response_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "commentations"
    t.index ["specialist_response_id"], name: "index_formulas_on_specialist_response_id"
  end

  create_table "help_desks", force: :cascade do |t|
    t.string "description"
    t.string "ticket"
    t.integer "status"
    t.bigint "user_id"
    t.bigint "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
    t.string "response_ticket"
    t.string "image_user"
    t.string "image_admin"
    t.bigint "admin_user_id"
    t.index ["admin_user_id"], name: "index_help_desks_on_admin_user_id"
    t.index ["device_id"], name: "index_help_desks_on_device_id"
    t.index ["user_id"], name: "index_help_desks_on_user_id"
  end

  create_table "history_tickets", force: :cascade do |t|
    t.string "message_create"
    t.string "message_assign"
    t.string "message_response"
    t.bigint "help_desk_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["help_desk_id"], name: "index_history_tickets_on_help_desk_id"
  end

  create_table "images_injuries", force: :cascade do |t|
    t.string "photo"
    t.text "description"
    t.bigint "injury_id"
    t.string "edited_photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "medical_control_id"
    t.text "commentations"
    t.integer "image_injury_id"
    t.index ["injury_id"], name: "index_images_injuries_on_injury_id"
    t.index ["medical_control_id"], name: "index_images_injuries_on_medical_control_id"
  end

  create_table "injuries", force: :cascade do |t|
    t.string "name"
    t.bigint "consultation_id"
    t.bigint "body_area_id"
    t.bigint "consultation_control_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.text "case_analysis"
    t.index ["body_area_id"], name: "index_injuries_on_body_area_id"
    t.index ["consultation_control_id"], name: "index_injuries_on_consultation_control_id"
    t.index ["consultation_id"], name: "index_injuries_on_consultation_id"
  end

  create_table "insurances", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
  end

  create_table "ips_insurances", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "insurance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_ips_insurances_on_client_id"
    t.index ["insurance_id"], name: "index_ips_insurances_on_insurance_id"
  end

  create_table "kits", force: :cascade do |t|
    t.string "code"
    t.bigint "prepay_card_client_id"
    t.bigint "device_id"
    t.bigint "contract_id"
    t.boolean "code_verified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_comodato", default: false
    t.datetime "init_date"
    t.datetime "end_date"
    t.index ["contract_id"], name: "index_kits_on_contract_id"
    t.index ["device_id"], name: "index_kits_on_device_id"
    t.index ["prepay_card_client_id"], name: "index_kits_on_prepay_card_client_id"
  end

  create_table "library_analyses", force: :cascade do |t|
    t.string "name"
    t.bigint "specialist_response_id"
    t.integer "type_analysis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specialist_response_id"], name: "index_library_analyses_on_specialist_response_id"
  end

  create_table "library_specialists", force: :cascade do |t|
    t.string "name"
    t.bigint "specialist_response_id"
    t.integer "specialist_id"
    t.bigint "formula_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["formula_id"], name: "index_library_specialists_on_formula_id"
    t.index ["specialist_id"], name: "index_library_specialists_on_specialist_id"
    t.index ["specialist_response_id"], name: "index_library_specialists_on_specialist_response_id"
  end

  create_table "medical_consultations", force: :cascade do |t|
    t.string "symptom"
    t.float "evolution_time"
    t.integer "unit_measurement"
    t.integer "number_injuries"
    t.string "evolution_injuries"
    t.boolean "blood"
    t.boolean "exude"
    t.boolean "suppurate"
    t.integer "change_symptom"
    t.string "other_factors_symptom"
    t.string "aggravating_factors"
    t.string "personal_history"
    t.string "family_background"
    t.string "treatment_received"
    t.string "applied_substances"
    t.string "treatment_effects"
    t.string "diagnostic_impression"
    t.text "description_physical_examination"
    t.string "physical_audio"
    t.string "annex_description"
    t.string "audio_annex"
    t.bigint "consultation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "weight"
    t.text "reason_consultation"
    t.text "current_illness"
    t.index ["consultation_id"], name: "index_medical_consultations_on_consultation_id"
  end

  create_table "medical_controls", force: :cascade do |t|
    t.integer "doctor_id"
    t.bigint "consultation_id"
    t.string "subjetive_improvement"
    t.boolean "did_treatment", default: false
    t.integer "tolerated_medications"
    t.text "audio_clinic"
    t.text "clinic_description"
    t.text "audio_annex"
    t.text "annex_description"
    t.text "annex_photo"
    t.bigint "consultation_control_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.index ["consultation_control_id"], name: "index_medical_controls_on_consultation_control_id"
    t.index ["consultation_id"], name: "index_medical_controls_on_consultation_id"
    t.index ["doctor_id"], name: "index_medical_controls_on_doctor_id"
  end

  create_table "mipres_files", force: :cascade do |t|
    t.string "mipres"
    t.bigint "specialist_response_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specialist_response_id"], name: "index_mipres_files_on_specialist_response_id"
  end

  create_table "municipalities", force: :cascade do |t|
    t.string "name"
    t.integer "code"
    t.bigint "department_id"
    t.integer "code_department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_municipalities_on_department_id"
  end

  create_table "nurse_consultations", force: :cascade do |t|
    t.string "ulcer_etiology"
    t.string "ulcer_etiology_other"
    t.integer "pain_intensity"
    t.integer "ulcer_length"
    t.integer "ulcer_width"
    t.string "infection_signs"
    t.string "wound_tissue"
    t.string "skin_among_ulcer"
    t.string "ulcer_handle"
    t.string "ulcer_handle_aposito"
    t.string "ulcer_handle_other"
    t.string "consultation_reason_description"
    t.string "consultation_reason_audio"
    t.integer "pulses_pedio"
    t.integer "pulses_femoral"
    t.integer "pulses_tibial"
    t.bigint "consultation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "weight"
    t.index ["consultation_id"], name: "index_nurse_consultations_on_consultation_id"
  end

  create_table "nurse_controls", force: :cascade do |t|
    t.integer "subjetive_improvement"
    t.integer "ulcer_length"
    t.integer "ulcer_width"
    t.integer "pain_intensity"
    t.boolean "tolerated_treatment"
    t.boolean "improvement"
    t.bigint "consultation_control_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "commentation"
    t.index ["consultation_control_id"], name: "index_nurse_controls_on_consultation_control_id"
  end

  create_table "other_diagnostics", force: :cascade do |t|
    t.bigint "specialist_response_id"
    t.bigint "disease_id"
    t.integer "type_diagnostic"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disease_id"], name: "index_other_diagnostics_on_disease_id"
    t.index ["specialist_response_id"], name: "index_other_diagnostics_on_specialist_response_id"
  end

  create_table "patient_informations", force: :cascade do |t|
    t.boolean "terms_conditions", default: false
    t.integer "unit_measure_age"
    t.integer "age"
    t.integer "civil_status"
    t.string "occupation"
    t.string "phone"
    t.string "email"
    t.string "address"
    t.bigint "municipality_id"
    t.integer "urban_zone"
    t.boolean "companion", default: false
    t.string "name_companion"
    t.string "phone_companion"
    t.boolean "responsible", default: false
    t.string "name_responsible"
    t.string "phone_responsible"
    t.string "relationship"
    t.integer "type_user"
    t.string "authorization_number"
    t.string "code_consultation"
    t.integer "purpose_consultation"
    t.integer "external_cause"
    t.integer "status"
    t.bigint "patient_id"
    t.bigint "insurance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["insurance_id"], name: "index_patient_informations_on_insurance_id"
    t.index ["municipality_id"], name: "index_patient_informations_on_municipality_id"
    t.index ["patient_id"], name: "index_patient_informations_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.integer "type_document"
    t.integer "type_condition"
    t.string "number_document"
    t.string "name"
    t.string "second_name"
    t.string "last_name"
    t.string "second_surname"
    t.date "birthdate"
    t.integer "genre"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number_inpec"
    t.index ["client_id"], name: "index_patients_on_client_id"
  end

  create_table "payment_histories", force: :cascade do |t|
    t.integer "credits"
    t.bigint "consultation_id"
    t.bigint "consultation_control_id"
    t.bigint "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consultation_control_id"], name: "index_payment_histories_on_consultation_control_id"
    t.index ["consultation_id"], name: "index_payment_histories_on_consultation_id"
    t.index ["device_id"], name: "index_payment_histories_on_device_id"
  end

  create_table "prepay_card_clients", force: :cascade do |t|
    t.datetime "purchase_date"
    t.bigint "prepay_card_id"
    t.bigint "contract_id"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_prepay_card_clients_on_client_id"
    t.index ["contract_id"], name: "index_prepay_card_clients_on_contract_id"
    t.index ["prepay_card_id"], name: "index_prepay_card_clients_on_prepay_card_id"
  end

  create_table "prepay_cards", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "credits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "request_exams", force: :cascade do |t|
    t.string "name_type_exam"
    t.bigint "specialist_response_id"
    t.integer "specialist_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specialist_id"], name: "index_request_exams_on_specialist_id"
    t.index ["specialist_response_id"], name: "index_request_exams_on_specialist_response_id"
  end

  create_table "request_images", force: :cascade do |t|
    t.string "image_request"
    t.bigint "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_request_images_on_request_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "comment"
    t.integer "type_request"
    t.bigint "consultation_id"
    t.integer "specialist_id"
    t.integer "doctor_id"
    t.string "audio_request"
    t.string "description_request"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "nurse_id"
    t.bigint "consultation_control_id"
    t.integer "reason"
    t.string "other_reason"
    t.index ["consultation_control_id"], name: "index_requests_on_consultation_control_id"
    t.index ["consultation_id"], name: "index_requests_on_consultation_id"
    t.index ["doctor_id"], name: "index_requests_on_doctor_id"
    t.index ["specialist_id"], name: "index_requests_on_specialist_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "specialist_responses", force: :cascade do |t|
    t.string "control_recommended"
    t.integer "specialist_id"
    t.bigint "consultation_id"
    t.bigint "consultation_control_id"
    t.boolean "sms_send"
    t.boolean "mail_send"
    t.string "case_analysis"
    t.string "analysis_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "nurse_id"
    t.index ["consultation_control_id"], name: "index_specialist_responses_on_consultation_control_id"
    t.index ["consultation_id"], name: "index_specialist_responses_on_consultation_id"
    t.index ["specialist_id"], name: "index_specialist_responses_on_specialist_id"
  end

  create_table "subsidiaries", force: :cascade do |t|
    t.string "name"
    t.string "identification"
    t.string "address"
    t.integer "type_subs"
    t.string "code_sds"
    t.string "post_code"
    t.string "email"
    t.string "phone_one"
    t.string "phone_two"
    t.bigint "client_id"
    t.bigint "kit_id"
    t.bigint "municipality_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_subsidiaries_on_client_id"
    t.index ["kit_id"], name: "index_subsidiaries_on_kit_id"
    t.index ["municipality_id"], name: "index_subsidiaries_on_municipality_id"
  end

  create_table "system_manuals", force: :cascade do |t|
    t.string "name"
    t.string "file_manual"
    t.integer "type_manual"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "traceability_admins", force: :cascade do |t|
    t.bigint "admin_user_id"
    t.boolean "create_admin", default: false
    t.boolean "update_admin", default: false
    t.boolean "delete_admin", default: false
    t.boolean "activate_admin", default: false
    t.boolean "desactivate_admin", default: false
    t.integer "user_admin_id"
    t.boolean "create_user", default: false
    t.boolean "delete_user", default: false
    t.boolean "activate_user", default: false
    t.boolean "desactivate_user", default: false
    t.bigint "user_id"
    t.boolean "delete_contact", default: false
    t.boolean "create_client", default: false
    t.boolean "update_client", default: false
    t.boolean "activate_client", default: false
    t.boolean "desactivate_client", default: false
    t.bigint "client_id"
    t.boolean "create_user_client", default: false
    t.boolean "update_user_client", default: false
    t.bigint "client_user_id"
    t.boolean "create_contract", default: false
    t.boolean "delete_contract", default: false
    t.bigint "contract_id"
    t.boolean "create_bill", default: false
    t.boolean "update_bill", default: false
    t.boolean "delete_bill", default: false
    t.bigint "bill_id"
    t.boolean "create_addition_contract", default: false
    t.bigint "additional_card_id"
    t.boolean "create_kit", default: false
    t.boolean "delete_kit", default: false
    t.bigint "kit_id"
    t.boolean "create_device", default: false
    t.boolean "update_device", default: false
    t.boolean "delete_device", default: false
    t.bigint "device_id"
    t.boolean "create_manual_system", default: false
    t.boolean "update_manual_system", default: false
    t.boolean "delete_manual_system", default: false
    t.bigint "system_manual_id"
    t.boolean "assign_help_desk", default: false
    t.boolean "reassign_help_desk", default: false
    t.boolean "response_help_desk", default: false
    t.bigint "help_desk_id"
    t.boolean "create_prepay_card", default: false
    t.boolean "update_prepay_card", default: false
    t.boolean "delete_prepay_card", default: false
    t.bigint "prepay_card_id"
    t.boolean "create_version", default: false
    t.boolean "update_version", default: false
    t.boolean "delete_version", default: false
    t.bigint "app_version_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_complete_admin"
    t.string "document_admin"
    t.string "rol"
    t.string "name_complete_user"
    t.string "document_user"
    t.integer "patients_attended"
    t.string "contract_number"
    t.datetime "date_init"
    t.datetime "date_end"
    t.string "code_bill"
    t.datetime "date_expedition"
    t.string "code_kit"
    t.boolean "is_comodato"
    t.string "imei"
    t.string "name_card"
    t.string "credits"
    t.boolean "assign_contact"
    t.boolean "response_contact"
    t.bigint "contact_id"
    t.string "email"
    t.string "phone"
    t.string "name_manual"
    t.string "file_name"
    t.integer "assign_consult_id"
    t.integer "reassign_consult_id"
    t.integer "assign_control_id"
    t.integer "reassign_control_id"
    t.bigint "consultation_id"
    t.bigint "consultation_control_id"
    t.index ["additional_card_id"], name: "index_traceability_admins_on_additional_card_id"
    t.index ["admin_user_id"], name: "index_traceability_admins_on_admin_user_id"
    t.index ["app_version_id"], name: "index_traceability_admins_on_app_version_id"
    t.index ["bill_id"], name: "index_traceability_admins_on_bill_id"
    t.index ["client_id"], name: "index_traceability_admins_on_client_id"
    t.index ["client_user_id"], name: "index_traceability_admins_on_client_user_id"
    t.index ["consultation_control_id"], name: "index_traceability_admins_on_consultation_control_id"
    t.index ["consultation_id"], name: "index_traceability_admins_on_consultation_id"
    t.index ["contact_id"], name: "index_traceability_admins_on_contact_id"
    t.index ["contract_id"], name: "index_traceability_admins_on_contract_id"
    t.index ["device_id"], name: "index_traceability_admins_on_device_id"
    t.index ["help_desk_id"], name: "index_traceability_admins_on_help_desk_id"
    t.index ["kit_id"], name: "index_traceability_admins_on_kit_id"
    t.index ["prepay_card_id"], name: "index_traceability_admins_on_prepay_card_id"
    t.index ["system_manual_id"], name: "index_traceability_admins_on_system_manual_id"
    t.index ["user_id"], name: "index_traceability_admins_on_user_id"
  end

  create_table "traceability_clients", force: :cascade do |t|
    t.bigint "client_user_id"
    t.integer "create_patient_id"
    t.boolean "shared_clinic_history", default: false
    t.boolean "print_clinic_history", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_user_id"], name: "index_traceability_clients_on_client_user_id"
  end

  create_table "traceability_consults", force: :cascade do |t|
    t.integer "doctor_id"
    t.bigint "consultation_id"
    t.bigint "user_id"
    t.integer "assign_consult_id"
    t.integer "reassign_consult_id"
    t.integer "seach_patient_id"
    t.bigint "client_user_id"
    t.boolean "shared_clinic_history", default: false
    t.boolean "print_clinic_history", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "response_req_id"
    t.integer "reject_req_id"
    t.integer "view_consult_id"
    t.integer "patient_specialist_id"
    t.boolean "type_condition", default: true
    t.integer "status"
    t.index ["client_user_id"], name: "index_traceability_consults_on_client_user_id"
    t.index ["consultation_id"], name: "index_traceability_consults_on_consultation_id"
    t.index ["user_id"], name: "index_traceability_consults_on_user_id"
  end

  create_table "traceability_controls", force: :cascade do |t|
    t.integer "doctor_id"
    t.bigint "consultation_control_id"
    t.bigint "user_id"
    t.integer "assign_control_id"
    t.integer "reassign_control_id"
    t.integer "seach_patient_id"
    t.bigint "client_user_id"
    t.boolean "shared_clinic_history", default: false
    t.boolean "print_clinic_history", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "response_req_id"
    t.integer "reject_req_id"
    t.integer "view_control_id"
    t.integer "patient_specialist_id"
    t.boolean "type_condition", default: true
    t.integer "status"
    t.index ["client_user_id"], name: "index_traceability_controls_on_client_user_id"
    t.index ["consultation_control_id"], name: "index_traceability_controls_on_consultation_control_id"
    t.index ["user_id"], name: "index_traceability_controls_on_user_id"
  end

  create_table "user_clients", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_user_clients_on_client_id"
    t.index ["user_id"], name: "index_user_clients_on_user_id"
  end

  create_table "user_tokens", force: :cascade do |t|
    t.bigint "user_id"
    t.string "old_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "number_document"
    t.integer "type_professional"
    t.string "professional_card"
    t.string "name"
    t.string "surnames"
    t.string "phone"
    t.boolean "terms_and_conditions", default: false
    t.integer "status", default: 1
    t.string "digital_signature"
    t.string "photo"
    t.string "image_digital"
    t.boolean "tutorial", default: false
    t.string "encrypted_password", default: "", null: false
    t.string "authentication_token", limit: 30
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "certified", default: false
    t.bigint "subsidiary_id"
    t.integer "type_specialist"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["subsidiary_id"], name: "index_users_on_subsidiary_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "additional_cards", "clients"
  add_foreign_key "additional_cards", "contracts"
  add_foreign_key "additional_cards", "prepay_cards"
  add_foreign_key "annex_images", "consultation_controls"
  add_foreign_key "annex_images", "consultations"
  add_foreign_key "audits", "devices"
  add_foreign_key "audits", "users"
  add_foreign_key "bills", "contracts"
  add_foreign_key "bills_insurances", "clients"
  add_foreign_key "bills_insurances", "ips_insurances"
  add_foreign_key "client_users", "clients"
  add_foreign_key "clients", "municipalities"
  add_foreign_key "consultation_controls", "consultations"
  add_foreign_key "consultation_controls", "patients"
  add_foreign_key "consultations", "patient_informations"
  add_foreign_key "consultations", "patients"
  add_foreign_key "contacts", "admin_users"
  add_foreign_key "contacts", "designed_responses"
  add_foreign_key "contracts", "clients"
  add_foreign_key "devices", "app_versions"
  add_foreign_key "devices", "kits"
  add_foreign_key "formulas", "specialist_responses"
  add_foreign_key "help_desks", "admin_users"
  add_foreign_key "help_desks", "devices"
  add_foreign_key "help_desks", "users"
  add_foreign_key "history_tickets", "help_desks"
  add_foreign_key "images_injuries", "injuries"
  add_foreign_key "images_injuries", "medical_controls"
  add_foreign_key "injuries", "body_areas"
  add_foreign_key "injuries", "consultation_controls"
  add_foreign_key "injuries", "consultations"
  add_foreign_key "ips_insurances", "clients"
  add_foreign_key "ips_insurances", "insurances"
  add_foreign_key "kits", "contracts"
  add_foreign_key "kits", "devices"
  add_foreign_key "kits", "prepay_card_clients"
  add_foreign_key "library_analyses", "specialist_responses"
  add_foreign_key "library_specialists", "formulas"
  add_foreign_key "library_specialists", "specialist_responses"
  add_foreign_key "medical_consultations", "consultations"
  add_foreign_key "medical_controls", "consultation_controls"
  add_foreign_key "medical_controls", "consultations"
  add_foreign_key "mipres_files", "specialist_responses"
  add_foreign_key "municipalities", "departments"
  add_foreign_key "nurse_consultations", "consultations"
  add_foreign_key "nurse_controls", "consultation_controls"
  add_foreign_key "other_diagnostics", "diseases"
  add_foreign_key "other_diagnostics", "specialist_responses"
  add_foreign_key "patient_informations", "insurances"
  add_foreign_key "patient_informations", "municipalities"
  add_foreign_key "patient_informations", "patients"
  add_foreign_key "patients", "clients"
  add_foreign_key "payment_histories", "consultation_controls"
  add_foreign_key "payment_histories", "consultations"
  add_foreign_key "payment_histories", "devices"
  add_foreign_key "prepay_card_clients", "clients"
  add_foreign_key "prepay_card_clients", "contracts"
  add_foreign_key "prepay_card_clients", "prepay_cards"
  add_foreign_key "request_exams", "specialist_responses"
  add_foreign_key "request_images", "requests"
  add_foreign_key "requests", "consultation_controls"
  add_foreign_key "requests", "consultations"
  add_foreign_key "specialist_responses", "consultation_controls"
  add_foreign_key "specialist_responses", "consultations"
  add_foreign_key "subsidiaries", "clients"
  add_foreign_key "subsidiaries", "kits"
  add_foreign_key "subsidiaries", "municipalities"
  add_foreign_key "traceability_admins", "additional_cards"
  add_foreign_key "traceability_admins", "admin_users"
  add_foreign_key "traceability_admins", "app_versions"
  add_foreign_key "traceability_admins", "bills"
  add_foreign_key "traceability_admins", "client_users"
  add_foreign_key "traceability_admins", "clients"
  add_foreign_key "traceability_admins", "consultation_controls"
  add_foreign_key "traceability_admins", "consultations"
  add_foreign_key "traceability_admins", "contacts"
  add_foreign_key "traceability_admins", "contracts"
  add_foreign_key "traceability_admins", "devices"
  add_foreign_key "traceability_admins", "help_desks"
  add_foreign_key "traceability_admins", "kits"
  add_foreign_key "traceability_admins", "prepay_cards"
  add_foreign_key "traceability_admins", "system_manuals"
  add_foreign_key "traceability_admins", "users"
  add_foreign_key "traceability_clients", "client_users"
  add_foreign_key "traceability_consults", "client_users"
  add_foreign_key "traceability_consults", "consultations"
  add_foreign_key "traceability_consults", "users"
  add_foreign_key "traceability_controls", "client_users"
  add_foreign_key "traceability_controls", "consultation_controls"
  add_foreign_key "traceability_controls", "users"
  add_foreign_key "user_clients", "clients"
  add_foreign_key "user_clients", "users"
  add_foreign_key "user_tokens", "users"
  add_foreign_key "users", "subsidiaries"
end
