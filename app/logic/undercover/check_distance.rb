class CheckDistance
  def self.perform(lng1, lat1, lng2, lat2)
    Geocoder::Calculations.distance_between([lng1,lat1], [lng2,lat2])
  end

  def messages_in_radius(post_code, current_lng, current_lat)
    network = Network.find_by(post_code: post_code)
    network.messages.where(undercover: true).each do |message|
      distance = Geocoder::Calculations.distance_between([current_lng,current_lat], [message.lng,message.lat])
      puts distance
    end
  end
end
