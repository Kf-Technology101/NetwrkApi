class ChooseType
  def self.start(login, country_code)
    code = generate_code
    if ValidateEmail.valid?(login)
      UserMailer.confirmation_mail(login, code).deliver_now
      type = {
        login_type: 'email',
        login_message: 'Confirmation email is sent',
        login_code: code
      }
      # TODO email sending
    elsif Phonelib.valid_for_country?(login, country_code)
      TwilioConnect.perform(login, code)
      type = {
        login_type: 'phone',
        login_message: 'Confirmation SMS is sent',
        login_code: code
      }
      # TODO sms sending
    else
      type = {login_type: 'error', login_message: 'Your login is incorrect'}
    end
  end

  def self.generate_code
    rand(100000..999999)
  end
end
