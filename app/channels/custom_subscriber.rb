class CustomSubscriber < ApplicationCable::Channel
  # class CustomSubscriber < ActionCable::Connection::Base
  # Can I just inherit from ActionCable::Connection::Base?
  # No, it causes 'Subscription class not found: "CustomSubscriber"'
  def subscribed
    Rails.logger.info "=" * 50
    Rails.logger.info "MAKSIM: CustomSubscriber#subscribed called"
    Rails.logger.info "MAKSIM: Params: #{params.inspect}"
    # MAKSIM: Params: {"channel" => "CustomSubscriber", "custom_param" => "Something from JS"}
    Rails.logger.info "MAKSIM: Connection: #{connection.inspect}"

    stream_from "custom_channel"

    Rails.logger.info "MAKSIM: Successfully streaming from 'custom_channel'"
    Rails.logger.info "=" * 50
    Rails.logger.info "MAKSIM: CustomSubscriber#subscribed current_user: #{current_user.inspect}"
    Rails.logger.info "MAKSIM: CustomSubscriber#subscribed user email: #{current_user&.email_address}"

    # Send a welcome message to confirm subscription
    transmit({
      custom_param: "Welcome #{current_user&.email_address}! Connected to CustomSubscriber at #{Time.current}",
      from_user: current_user&.email_address
    })
  end

  def receive(data)
    # This is called when client sends data using subscription.perform('action', data)
    Rails.logger.info "MAKSIM: CustomSubscriber#receive called with data: #{data.inspect}"
    Rails.logger.info "MAKSIM: Received from user: #{current_user&.email_address}"

    # Broadcast the message to all subscribers
    ActionCable.server.broadcast("custom_channel", {
      custom_param: data["message"],
      from_user: current_user&.email_address,
      timestamp: Time.current
    })
  end

  def unsubscribed
    Rails.logger.info "MAKSIM: CustomSubscriber#unsubscribed called"
    Rails.logger.info "MAKSIM: Stopped streaming from 'custom_channel'"
    Rails.logger.info "MAKSIM: CustomSubscriber#unsubscribed current_user: #{current_user.inspect}"
    Rails.logger.info "MAKSIM: User #{current_user&.email_address} disconnected"
  end
end

# ActionCable.server.broadcast("custom_channel", { custom_param: "It's something here at #{Time.current}" })
