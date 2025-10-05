class CustomChannelTestController < ApplicationController
  def index
  end

  def broadcast_test
    message = { custom_param: "Test message from controller at #{Time.current}" }

    puts "=" * 50
    puts "Broadcasting to 'custom_channel': #{message.inspect}"

    Rails.logger.info "=" * 50
    Rails.logger.info "Broadcasting to 'custom_channel': #{message.inspect}"

    ActionCable.server.broadcast("custom_channel", message)

    Rails.logger.info "Broadcast sent successfully"
    Rails.logger.info "=" * 50

    puts "Broadcast sent successfully"
    puts "=" * 50

    respond_to do |format|
      format.turbo_stream { head :ok }
      format.html { redirect_to custom_channel_test_path, notice: "Broadcast sent!" }
    end
  end
end
