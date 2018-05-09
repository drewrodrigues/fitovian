class MessageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.contact_us.subject
  #
  def updates(email)
    @email = email

    mail to: 'ernie@fitovian.com', subject: "#{@email} wants to receive updates"
  end
end
