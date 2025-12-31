class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    @workspace = user.workspace

    mail(
      to: @user.email_address,
      subject: "Welcome to DoneYet - Mission Control Ready"
    )
  end
end
