require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:active) }
    it { is_expected.to validate_presence_of(:current_period_end) }
    it { is_expected.to validate_presence_of(:stripe_id) }
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:active) }
    it { is_expected.to have_db_column(:current_period_end) }
    it { is_expected.to have_db_column(:stripe_id) }
    it { is_expected.to have_db_column(:subscribed) }
  end

  describe '#subscribe' do
    context 'user subscribed' do
      it 'returns true'
    end

    context 'user not subscribed' do
      it 'returns true'
    end

    context 'errored api call' do
      it 'returns false'
    end
  end

  describe '#cancel' do
    context 'user subscribed' do
      it 'returns true'
    end

    context 'user not-subscribed' do
      it 'returns true'
    end

    context 'errored api call' do
      it 'returns false'
    end
  end

  describe '#re_activate' do
    context 'user already subscribed' do
      it 'returns true'
    end

    context 'user not subscribed' do
      it 'returns false'
    end

    context 'errored api call' do
      it 'returns false'
    end
  end

  describe '#update_end_date(event)' do
    context 'upon incoming webhook' do
      it 'sets current_period end to a month out'

      it 'returns true'
    end
  end
end
