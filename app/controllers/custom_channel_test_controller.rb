class CustomChannelTestController < ApplicationController
  def index
    Rails.logger.debug "MAKSIM: CustomChannelTestController Current.user: #{Current.user.inspect}"
  end

  def broadcast_test
    message = {
      custom_param: "Test message from controller at #{Time.current}",
      from_user: Current.user.email_address
    }
    Rails.logger.info "=" * 50
    Rails.logger.info "MAKSIM: Broadcasting to 'custom_channel': #{message.inspect}"

    ActionCable.server.broadcast("custom_channel", message)

    Rails.logger.info "MAKSIM: Broadcast sent successfully"
    Rails.logger.info "=" * 50
    Rails.logger.info "MAKSIM: broadcast_test Current.user: #{Current.user.inspect}"

    respond_to do |format|
      format.turbo_stream { head :ok }
      format.html { redirect_to custom_channel_test_path, notice: "Broadcast sent!" }
    end
  end
end
