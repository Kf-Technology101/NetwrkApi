class ChooseType
  def self.start(login, country_code)
    if ValidateEmail.valid?(login)
      type = {
        login_type: 'email',
        login_message: 'Confirmation email is already sent',
        login_code: '1234'
      }
      # TODO email sending
    elsif Phonelib.valid_for_country?(login, country_code)
      type = {
        login_type: 'phone',
        login_message: 'Confirmation SMS is already sent',
        login_code: '1234'
      }
      # TODO sms sending
    else
      type = {login_type: 'error', login_message: 'Your login is incorrect'}
    end
  end
end
