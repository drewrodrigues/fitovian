class MessageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.contact_us.subject
  #
  def contact_us(body, email, name)
    @email = email
    @body = body
    @name = name

    mail to: 'ernie@wcwlc.com', subject: "Contact Us: From #{email}"
  end

  def updates(email)
    @email = email

    mail to: 'ernie@wcwlc.com', subject: "#{@email} wants to receive updates"
  end
end
