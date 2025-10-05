class CustomSubscriber < ApplicationCable::Channel
  # class CustomSubscriber < ActionCable::Connection::Base
  # Can I just inherit from ActionCable::Connection::Base?
  # No, causes 'Subscription class not found: "CustomSubscriber"'
  def subscribed
    Rails.logger.info "=" * 50
    Rails.logger.info "MAKSIM: CustomSubscriber#subscribed called"
    Rails.logger.info "MAKSIM: Params: #{params.inspect}"
    # MAKSIM: Params: {"channel" => "CustomSubscriber", "custom_param" => "Something from JS"}
    Rails.logger.info "MAKSIM: Connection: #{connection.inspect}"

    stream_from "custom_channel"

    Rails.logger.info "MAKSIM: Successfully streaming from 'custom_channel'"
    Rails.logger.info "=" * 50

    # Send a welcome message to confirm subscription
    transmit({ custom_param: "Welcome from channels/custom_subscriber.rb. Connected to CustomSubscriber at #{Time.current}" })
  end

  def receive(data)
    # MAKSIM: This is not called
    Rails.logger.info "MAKSIM: CustomSubscriber#receive called with data: #{data.inspect}"
  end

  def unsubscribed
    Rails.logger.info "MAKSIM: CustomSubscriber#unsubscribed called"
    Rails.logger.info "MAKSIM: Stopped streaming from 'custom_channel'"
  end
end

# ActionCable.server.broadcast("custom_channel", { custom_param: "It's something here at #{Time.current}" })
