class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #

  def reset_password(user)
    @user = user
    mail to: user.email , :subject => "Password Reset Instructions"
  end

end

