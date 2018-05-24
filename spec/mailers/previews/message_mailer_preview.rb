# Preview all emails at http://localhost:3000/rails/mailers/message_mailer
class MessageMailerPreview < ActionMailer::Preview
  def updates
    MessageMailer.updates('test@example.com')
  end

  def welcome
    MessageMailer.welcome('test@example.com')
  end
end
