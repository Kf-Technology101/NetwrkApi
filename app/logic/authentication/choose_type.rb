class ChooseType
  def self.start(login, country_code)
    if ValidateEmail.valid?(login)
      type = {
        type: 'email',
        message: 'Confirmation email is already sent',
        code: '1234'
      }
      # TODO email sending
    elsif Phonelib.valid_for_country?(login, country_code)
      type = {
        type: 'email',
        message: 'Confirmation SMS is already sent',
        code: '1234'
      }
      # TODO sms sending
    else
      type = {type: 'error', message: 'Your login is incorrect'}
    end
  end
end
