# Initialize server-side ActionCable subscriber
Rails.application.config.after_initialize do
  # Only start in development and production environments
  # Skip in test environment to avoid interference with tests
  if Rails.env.development? || Rails.env.production?
    begin
      # Require the basic subscriber class
      require_relative '../../lib/server_side_subscriber'

      # Create and start the subscriber
      Rails.application.config.server_side_subscriber = ServerSideSubscriber.new
      Rails.application.config.server_side_subscriber.start

      Rails.logger.info "ServerSideSubscriber: Initialized and started successfully"

      # Broadcast a startup message
      ActionCable.server.broadcast(
      "custom_channel",
      {
          custom_param: "Server-side subscriber started at #{Time.current}",
          source: "server_startup"
      }
      )
    rescue => e
      Rails.logger.error "Failed to initialize ServerSideSubscriber: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end

# Ensure we stop the subscriber when the application shuts down
at_exit do
  if Rails.application.config.respond_to?(:server_side_subscriber) &&
     Rails.application.config.server_side_subscriber
    Rails.logger.info "Shutting down ServerSideSubscriber..."

    if Rails.application.config.server_side_subscriber.respond_to?(:stop)
      Rails.application.config.server_side_subscriber.stop
    elsif Rails.application.config.server_side_subscriber.respond_to?(:unsubscribe_all)
      Rails.application.config.server_side_subscriber.unsubscribe_all
    end
  end
end
