namespace :cable do
  desc "Test server-side ActionCable subscriber"
  task test_subscriber: :environment do
    puts "=" * 50
    puts "Testing Server-Side ActionCable Subscriber"
    puts "=" * 50

    # Check if subscriber is running
    if Rails.application.config.respond_to?(:server_side_subscriber) &&
       Rails.application.config.server_side_subscriber
      puts "✓ Server-side subscriber is running"

      # Get subscriber info
      subscriber = Rails.application.config.server_side_subscriber

      if subscriber.respond_to?(:active_subscriptions)
        puts "✓ Active subscriptions: #{subscriber.active_subscriptions.join(', ')}"
      end

      # Send test broadcasts
      puts "\nSending test broadcasts..."

      3.times do |i|
        message = {
          custom_param: "Test broadcast ##{i + 1} from rake task at #{Time.current}",
          source: "rake_task",
          test_number: i + 1
        }

        puts "Broadcasting: #{message[:custom_param]}"
        ActionCable.server.broadcast("custom_channel", message)

        sleep 0.5  # Small delay between broadcasts
      end

      puts "\n✓ Test broadcasts sent!"
      puts "Check your Rails logs to see the server-side subscriber receiving these messages."

      # If using advanced subscriber, show message counts
      if subscriber.respond_to?(:subscriptions)
        puts "\nSubscription stats:"
        subscriber.subscriptions.each do |channel, info|
          puts "  #{channel}: #{info[:message_count]} messages received"
        end
      end
    else
      puts "✗ Server-side subscriber is not running!"
      puts "Make sure your Rails server is running in development or production mode."
    end

    puts "=" * 50
  end

  desc "Monitor ActionCable broadcasts in real-time"
  task monitor: :environment do
    require_relative '../advanced_server_subscriber'

    puts "=" * 50
    puts "ActionCable Monitor - Press Ctrl+C to stop"
    puts "=" * 50

    # Create a monitoring subscriber
    monitor = AdvancedServerSubscriber.new

    # Subscribe to custom channel with detailed logging
    monitor.subscribe('custom_channel',
      on_message: ->(data, channel) {
        puts "\n[#{Time.current.strftime('%H:%M:%S')}] Received on '#{channel}':"
        puts "  Data: #{data.inspect}"
        puts "  Source: #{data['source'] || 'unknown'}" if data.is_a?(Hash)
      },
      on_error: ->(error, data, channel) {
        puts "\n[ERROR] on '#{channel}': #{error.message}"
      }
    )

    puts "\nMonitoring 'custom_channel'..."
    puts "Open your app in a browser or run 'rails cable:test_subscriber' in another terminal"

    # Keep the task running
    begin
      loop { sleep 1 }
    rescue Interrupt
      puts "\n\nStopping monitor..."
      monitor.unsubscribe_all
      puts "Monitor stopped."
    end
  end
end
