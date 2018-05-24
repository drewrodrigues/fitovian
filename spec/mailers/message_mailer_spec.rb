require 'rails_helper'

RSpec.describe MessageMailer, type: :mailer do
  let(:email) { 'test@example.com'}

  describe '#updates' do
    it 'renders the header' do
      mail = MessageMailer.updates(email)

      expect(mail.subject).to eq("#{email} wants to receive updates")
      expect(mail.to.first).to eq('ernie@fitovian.com')
      expect(mail.from.first).to eq('noreply@fitovian.com')
    end
  end

  describe '#welcome' do
    it 'renders the header' do
      mail = MessageMailer.welcome(email)

      expect(mail.subject).to eq('Welcome to Fitovian!')
      expect(mail.to.first).to eq(email)
      expect(mail.from.first).to eq('noreply@fitovian.com')
    end
  end
end
