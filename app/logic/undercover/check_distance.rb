class CheckDistance
  def self.perform(lng1, lat1, lng2, lat2)
    Geocoder::Calculations.distance_between([lng1,lat1], [lng2,lat2])
  end
end
