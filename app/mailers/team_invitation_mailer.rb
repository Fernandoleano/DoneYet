class TeamInvitationMailer < ApplicationMailer
  def invite(user, inviter, password)
    @user = user
    @inviter = inviter
    @password = password
    @workspace = user.workspace

    mail(
      to: @user.email_address,
      subject: "CLASSIFIED: Recruitment Offer from Agent #{@inviter.name}"
    )
  end
end
