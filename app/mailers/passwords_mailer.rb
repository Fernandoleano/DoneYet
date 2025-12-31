class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: "Secure Access Recovery Protocol", to: user.email_address
  end
end
