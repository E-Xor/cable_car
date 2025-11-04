class TimerUpdateJob < ApplicationJob
  queue_as :default

  def perform
    # Broadcast time update via Turbo Stream
    Turbo::StreamsChannel.broadcast_update_to(
      "timer_updates",
      target: "timer",
      html: Time.current.strftime("%Y-%m-%d %H:%M:%S")
    )

    Rails.logger.info "MAKSIM: TimerUpdateJob broadcast at #{Time.current}"
  end
end
