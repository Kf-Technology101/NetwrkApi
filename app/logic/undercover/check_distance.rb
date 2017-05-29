class CheckDistance
  def self.perform(lng1, lat1, lng2, lat2)
    Geocoder::Calculations.distance_between([lng1,lat1], [lng2,lat2])
  end

  def self.messages_in_radius(post_code, current_lng, current_lat, user_id, undercover)
    messages_in_radius = []
    user = User.find_by(id: user_id)
    network = Network.find_by(post_code: post_code)
    network.messages.where(undercover: true).each do |message|
      next unless message.lat.to_s[0..4] == current_lat.to_s[0..4] && message.lng.to_s[0..4] == current_lng.to_s[0..4]
      distance = Geocoder::Calculations.distance_between([current_lng,current_lat], [message.lng,message.lat])
      message.current_user = user
      if in_radius?(miles_to_yards(distance)) && !message.deleted_by_user?
        messages_in_radius << message
      end
    end
    messages_in_radius
  end

  def self.miles_to_yards(miles)
    miles * 1760
  end

  def self.in_radius?(yards)
    yards <= 100
  end
end
