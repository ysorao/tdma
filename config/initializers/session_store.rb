#Rails.application.config.session_store :active_record_store, key: '_Telederma_session', damain: :all
Rails.application.config.session_store :cookie_store, key: '_telederma_session', domain: :all
