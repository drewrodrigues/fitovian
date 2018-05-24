class MessageMailer < ApplicationMailer
  def updates(email)
    mail to: 'ernie@fitovian.com', subject: "#{email} wants to receive updates"
  end

  def welcome(email)
    mail to: email, subject: 'Welcome to Fitovian!'
  end
end
