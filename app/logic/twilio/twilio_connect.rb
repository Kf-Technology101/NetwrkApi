class TwilioConnect
  def self.twilio
    Twilio::REST::Client.new
  end

  def self.perform(phone, code)
    twilio.messages.create(
      from: '+333333333',
      to: phone,
      body: code
    )
  end
end
