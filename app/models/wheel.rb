class Wheel < ApplicationRecord
  broadcasts_to -> (broadcasted_obj) { Rails.logger.debug "broadcasted_obj: #{broadcasted_obj.inspect}"; :wheel_stream }, target: 'i-dont-see-its-used', partial: 'wheels/wheel_stream_partial'
end
