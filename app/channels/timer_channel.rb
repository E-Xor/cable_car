class TimerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "timer_updates"
  end
end
