module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      set_current_user || reject_unauthorized_connection
    end

    private

    def set_current_user
      if session = Session.find_by(id: cookies.signed[:session_id])
        Rails.logger.info "MAKSIM: ApplicationCable::Connection#set_current_user session.user: #{session.user.inspect}"
        self.current_user = session.user
      end
    end
  end
end
