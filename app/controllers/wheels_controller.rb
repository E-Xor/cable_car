class WheelsController < ApplicationController
  def index
    Rails.logger.debug "MAKSIM WheelsController Current.user: #{Current.user.inspect}"
    @latest_wheel = Wheel.order(:updated_at).last
  end

  def animate
    @random_position = rand(3600).to_f/10
    respond_to do |format|
      format.turbo_stream
    end
  end

  def update_latest_wheel
    Wheel.order(:updated_at).last.update(angle_position: params.require(:angle_position))
    # When using default partial in `broadcast_to`,
    # this method works without render, respond_to or any view,
    # the page just stays at the index page.

    # With custom partial I need to use the explicit render
    render json: {}, status: :no_content
  end
end
