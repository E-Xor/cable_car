module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      Rails.logger.info "=" * 50
      Rails.logger.info "ApplicationCable::Connection#connect called"
      Rails.logger.info "Request headers: #{request.headers.to_h.select { |k, v| k.start_with?('HTTP_') }}"
      Rails.logger.info "=" * 50
    end

    def disconnect
      Rails.logger.info "ApplicationCable::Connection#disconnect called"
    end
  end
end
