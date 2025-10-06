class DirectoryController < ApplicationController
  def index
    Rails.logger.debug "MAKSIM DirectoryController Current.user: #{Current.user.inspect}"
  end
end
