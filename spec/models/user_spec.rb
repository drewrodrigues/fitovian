require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:cards) }
    it { is_expected.to have_one(:plan) }
    it { is_expected.to have_one(:subscription) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:admin) }
    it { is_expected.to have_db_column(:email) }
    it { is_expected.to have_db_column(:name) }
    it { is_expected.to have_db_column(:stripe_id) }
  end

  describe 'factories' do
    it 'has a valid base factory' do
      expect(build_stubbed(:user)).to be_valid
    end

    it 'has a valid admin factory' do
      expect(build_stubbed(:admin)).to be_valid
    end
  end

  describe '#set_stripe_id' do
    context 'when api call is successful' do
      let(:user) { create(:user) }

      it 'adds a stripe_id upon creation' do
        expect(user.stripe_id).to_not be_nil
      end
    end

    context 'when api call throws an error' do
      before do
        stripe_error = Stripe::StripeError.new('Pretend stripe error')
        StripeMock.prepare_error(stripe_error, :new_customer)
      end

      it 'prevents user creation' do
        user = build(:user)
        expect(user.stripe_id).to be_nil
        expect(user.save).to be false
      end
    end
  end

  describe '#stripe_customer' do
    context 'when api call is successful' do
      it 'returns the stripe customer' do
        expect(create(:user).stripe_customer.class).to eq(Stripe::Customer)
      end
    end

    context 'when api call throws an error' do
      let(:user) { create(:user) }

      before do
        stripe_error = Stripe::StripeError.new('Pretend stripe error')
        StripeMock.prepare_error(stripe_error, :get_customer)
      end

      it 'returns false' do
        expect(user.stripe_customer).to be false
      end
    end
  end

  # TODO: text new implementation of subscribe and cancel

  # describe '#select_starter_plan' do
  #   context 'when user doesn\'t have a subscription yet' do
  #     it 'sets the users plan'
  #   end

  #   context 'when user has an active subscription' do
  #     it 'sets the users plan'
  #     it 'sets the Stripe Subscription to the chosen plan'
  #   end

  #   context 'when user has an in-active subscription' do
  #     it 'subscribes the user to the plan'
  #     it 'sets the Stripe Subscription to the chosen plan'
  #   end
  # end

  # describe '#select_premium_plan' do
  #   context 'when user doesn\'t have a subscription yet' do
  #     it 'sets the users plan'
  #   end

  #   context 'when user has an active subscription' do
  #     it 'sets the users plan'
  #     it 'sets the Stripe Subscription to the chosen plan'
  #   end

  #   context 'when user has an in-active subscription' do
  #     it 'subscribes the user to the plan'
  #     it 'changes the Stripe Subscription to the chosen plan'
  #   end
  # end
end
