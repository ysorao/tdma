Rails.application.routes.draw do

  default_url_options host: "https://telederma.gov.co" if Rails.env == "production"
  default_url_options host: "http://localhost:3000" if Rails.env == "development"

  devise_for :client_users, controllers: { sessions: 'client_users/sessions', registrations: 'client_users/registrations', passwords: 'client_users/passwords', confirmations: 'client_users/confirmations', unlocks: "client_users/unlocks"}
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords', confirmations: 'users/confirmations', unlocks: "users/unlocks"}
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_scope :user do
    #root to: "users/sessions#new"
  end

  root to: "landing/home#index"


  #LANDING PAGE
  namespace :landing do
    resources :home do #:path => "books"
      collection do
        get 'home'
        get 'about_us'
        get 'services'
        get 'support'
        get 'sales_contact'
        post 'form_contact'
        get 'terms'
        get 'event'
      end
    end
  end

  #ADMINISTRADOR
  namespace :admin do
    resources :mesa_ayuda do
      collection do
        put 'assign_update'
        put 'response_update'
      end
    end
    resources :contact do
      collection do
        put 'assign_update'
        put 'response_update'
      end
    end
    resources :consultation do 
      collection do
        get 'search_consults'
      end
    end
    resources :traceability_admin do
      collection do
        put 'assignment'
      end
    end
  end

  #ESPECIALISTA
  namespace :specialists do
	  resources :especialista do
      collection do
        get 'generate_certified'
        get 'search_patient'
        put 'assign_massive'
        put 'reasign_consult'
      end
      member do
        put 'edit_profile'
      end
    end
	end

  #CLIENTE IPS
  namespace :clients do
    resources :cliente do 
      collection do
        get 'subsidiaries'
        get 'new_subsidiary'
        get 'kits'
        get 'professionals'
        get 'new_professional'
        post 'create_professional'
        get 'search_patient'
        get 'generate_history_clinic'
        get 'new_patient'
        post 'create_patient'
        get 'insurances'
        put 'update_status'
        get 'generate_rips'
        get 'bills_insurances'
        get 'new_bill_insurance'
        get 'users'
        get 'new_user'
        put 'update_user_status'
        post 'create_user'
        get 'system_manuals'
      end
      member do
        get 'show_professional'
        put 'send_history_clinic'
        get 'edit'
      end
    end
  end

  #ENFERMERA
  namespace :nurses do
    resources :enfermera do
      collection do
        get 'generate_certified'
        get 'search_patient'
      end
      member do
        put 'edit_profile'
      end
    end
  end

	namespace :client do
	end

	namespace :admin do 	
	end

  #REST-API 
	namespace :api do
		namespace :v1 do
      namespace :especialista do
        resources :consult do
          collection do 
            post 'create_library_treatment'
            post 'create_library_formula'
            post 'create_request_exam'
            post 'create_formula'
            post 'create_formula_mipress'
            post 'create_next_control'
            post 'create_request'
            get 'get_info_specialist'
            get 'get_history'
            put 'response_consult'
            get 'get_library_treatment'
            get 'get_autocomplete_diagnostic'
            get 'get_treatment_specialist'
            delete 'delete_library_treatment'
            get 'get_library_formula'
            get 'get_formula_specialist'
            delete 'delete_library_formula'
            get 'get_charge_images'
            get 'get_edit_images'
            post 'create_specialist_response'
            get 'get_diagnostic_consult'
            get 'evolution_consults'
            get 'get_consults_control'
            get 'client_credits'
            put 'update_remission_consult'
            put 'edit_consult'
            get 'show_info'
            get 'evolution_consults'
            get 'get_consults_control'
            get 'evolution_specialist'
            get 'get_response_specialist'
            post 'create_library_analysis'
            get 'get_library_injury_analysis'
            get 'get_injury_analysis_specialist'
            delete 'delete_library_injury_analysis'
            get 'get_library_case_analysis'
            get 'get_case_analysis_specialist'
            delete 'delete_library_case_analysis'
            get 'dermatoscopy_images'
          end
          member do
            put 'update_specialist_consultation'
            put 'update_images_injury'
          end
        end
      end
      namespace :cliente do
        resources :admin_ips do
          collection do
            get 'get_subsidiary'
            post 'create_subsidiaries'
            delete 'delete_subsidiaries'
            get 'get_insurances'
            post 'create_insurance'
            delete 'delete_insurances'
            get 'get_kits_client'
            get 'get_bills_insurances'
            post 'create_bill_insurance'
            delete 'delete_bills_insurance'
          end 
        end
      end  
      namespace :enfermera do
        resources :nurse_consult do
          collection do 
            post 'create_next_control'
            post 'create_request'
            get 'get_info_nurse'
            get 'get_history'
            put 'response_consult'
            get 'get_charge_images'
            get 'get_edit_images'
            post 'create_specialist_response'
            get 'show_info'
            put 'update_remission_consult'
          end
          member do
            put 'update_nurse_consultation'
            put 'update_images_injury'
          end 
        end
      end



      #USUARIOS
		  resources :sessions, except: [:index, :show, :create, :new, :edit, :destroy] do
        collection do
          post "login"
          post "register"
          post "forget_password"
          get 'certificated'
          put 'tutorial'
        end
      end
			
      #PACIENTE
      resources :patients, except: [:index, :update, :new, :edit, :destroy]
      #CONSULTAS
      resources :consultations, except: [:show, :new, :edit] do
        collection do
          post 'archived_consultation'
          post 'shared_consultations'
          post 'shared_formula_mipres'
          post 'traceability'
          get 'show_information'
          get 'all_information'
        end
        member do
          put 'response_request'
          put 'reject_request'
        end
      end
      #CONSULTAS ENFERMERÍA
      resources :nurse_consultations, except: [:show, :new, :edit]
      #CONTROLES ENFERMERA
      resources :nurse_controls, except: [:show, :new, :edit]
      #LESIONES
      resources :injuries, except: [:index, :show, :update, :new, :edit, :destroy] do
        collection do
          post 'individual_image'
        end
      end
      #CONTROLES MEDICOS
      resources :medical_controls, except: [:index, :show, :update, :new, :edit, :destroy]
      #RECURSOS ESTATICOS
      resources :static_resources, except: [:index, :show, :create, :update, :new, :edit, :destroy] do
        collection do
          get 'departments'
          get 'system_constants'
          get 'insurances'
          get 'body_areas'
          get 'diseases'
          get 'get_municipalities'
          get 'get_insurances'
          get 'municipalities'
          get 'all_insurances'
          get 'get_ips_insurances'
          get 'access'
          get 'device'
          get 'get_designed_responses'
          get 'get_diseases'
        end
      end

      #GESTIÓN
      resources :managements, except: [:show, :new, :edit, :destroy]
		end	
	end
end
