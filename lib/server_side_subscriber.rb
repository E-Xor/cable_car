# Server-side ActionCable subscriber that connects when Rails starts
class ServerSideSubscriber
  include ActionCable::Connection::Callbacks

  attr_reader :pubsub, :identifier, :channel

  def initialize
    @identifier = { channel: 'CustomSubscriber', custom_param: 'Server-side subscription' }.to_json
    @channel = 'custom_channel'
    @pubsub = ActionCable.server.pubsub

    Rails.logger.info "=" * 50
    Rails.logger.info "ServerSideSubscriber: Initializing server-side subscriber"
    Rails.logger.info "=" * 50
  end

  def start
    Rails.logger.info "ServerSideSubscriber: Starting subscription to '#{@channel}'"

    # Subscribe to the channel via the pubsub adapter
    @pubsub.subscribe(@channel, method(:handle_broadcast))

    Rails.logger.info "ServerSideSubscriber: Successfully subscribed to '#{@channel}'"
    Rails.logger.info "ServerSideSubscriber: Waiting for broadcasts..."
    Rails.logger.info "=" * 50
  end

  def stop
    Rails.logger.info "ServerSideSubscriber: Stopping subscription"
    @pubsub.unsubscribe(@channel, method(:handle_broadcast))
    Rails.logger.info "ServerSideSubscriber: Unsubscribed from '#{@channel}'"
  end

  private

  def handle_broadcast(data)
    Rails.logger.info "=" * 50
    Rails.logger.info "ServerSideSubscriber: Received broadcast on '#{@channel}'"
    Rails.logger.info "ServerSideSubscriber: Data: #{data.inspect}"

    begin
      parsed_data = JSON.parse(data) if data.is_a?(String)
      parsed_data ||= data
      Rails.logger.info "ServerSideSubscriber: Parsed data: #{parsed_data.inspect}"

      process_server_side_message(parsed_data)
    rescue JSON::ParserError => e
      Rails.logger.error "ServerSideSubscriber: Failed to parse JSON: #{e.message}"
    end

    Rails.logger.info "=" * 50
  end

  def process_server_side_message(data)
    # Add your server-side processing logic here
    # Example: You could trigger background jobs, update caches, etc.
    # ActiveJob.perform_later(ProcessBroadcastJob, data)
    Rails.logger.info "ServerSideSubscriber: Processing message server-side..."

    if data['custom_param']
      Rails.logger.info "ServerSideSubscriber: Custom param received: #{data['custom_param']}"
    end
  end
end
