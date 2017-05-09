class UserMailer < ApplicationMailer
  def invitation_mail(name, email)
    @name = name
    @email = email
    mail(to: @email, subject: 'Invitation for Sign Up')
  end

  def greetings_mail(email)
    @name = name
    @email = email
    mail(to: @email, subject: 'Invitation for Sign Up')
  end

  def confirmation_mail(email, code)
    @email = email
    @code = code
    mail(to: @email, subject: 'Your confirmation code...')
  end
end
