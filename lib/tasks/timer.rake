namespace :timer do
  desc "Continuously broadcast timer updates every second"
  task broadcast: :environment do
    puts "Starting timer broadcast... Press Ctrl+C to stop"

    loop do
      begin
        current_time = Time.current.strftime("%Y-%m-%d %H:%M:%S")

        Turbo::StreamsChannel.broadcast_update_to(
          "timer_updates",
          target: "timer-element",
          html: current_time
        )

        print "\r#{current_time}"
        $stdout.flush

        sleep 1
      rescue Interrupt
        puts "\nTimer broadcast stopped."
        break
      rescue => e
        puts "\nError broadcasting timer: #{e.message}"
      end
    end
  end
end
