class TwilioConnect
  def self.twilio
    Twilio::REST::Client.new
  end

  def self.perform(phone, code)
    twilio.messages.create(
      from: '+18123016214 ',
      to: phone,
      body: code
    )
  end
end
