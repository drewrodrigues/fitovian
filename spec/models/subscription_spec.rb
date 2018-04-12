require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'validations' do
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

  before(:all) do
    StripeMock.start
    StripeMock.create_test_helper.create_plan(:id => 'starter', :amount => 1999)
  end

  before(:each) do
    @user = create(:user)
    @user.select_starter_plan
    @user.add_fake_card
  end

  after(:all) do
    StripeMock.stop
  end

  describe '#subscribe' do
    context 'user subscribed' do
      it 'returns true' do
        @user.subscribe
        expect(@user.subscribe).to be_truthy
      end
    end

    context 'user not subscribed' do
      it 'returns true' do
        expect(@user.subscribe).to be_truthy
      end
    end

    context 'user doesn\'t have plan' do
      it 'raises an error' do
        @user.plan = nil
        expect { @user.subscribe }.to raise_error {|e| 
          expect(e.message).to eq('Please choose a plan before subscribing')
        }
      end
    end

    context 'user doesn\'t have card' do
      it 'raises an error' do
        @user.cards.destroy_all
        expect { @user.subscribe }.to raise_error {|e|
          expect(e.message).to eq('Please add a credit card before subscribing')
        }
      end
    end

    context 'errored api call' do
      it 'allows error to fall through' do
        StripeMock.prepare_card_error(:card_declined, :create_subscription)
        expect { @user.subscribe }.to raise_error {|e|
          expect(e.message).to eq('The card was declined')
        }
      end
    end
  end

  describe '#cancel' do
    context 'user subscribed' do
      it 'returns true' do
        @user.subscribe
        expect(@user.cancel).to be_truthy
      end
    end

    context 'user not-subscribed' do
      it 'returns true' do
        expect(@user.cancel).to be_truthy
      end
    end
  end

  describe '#re_activate' do
    context 'user already subscribed' do
      it 'returns true' do
        @user.subscribe
        expect(@user.re_activate).to be_truthy
      end
    end

    context 'user not subscribed' do
      it 'returns false' do
        expect(@user.re_activate).to be false
      end
    end
  end

  describe '#update_end_date(event)' do
    context 'upon incoming webhook' do
      it 'sets current_period end to a month out'
      it 'returns true'
    end
  end
end
