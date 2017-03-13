class UserMailer < ApplicationMailer
  def invitation_mail(name, email)
    @name = name
    @email = email
    mail(to: @email, subject: 'Invitation for Sign Up')
  end
end
