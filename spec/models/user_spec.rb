require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    StripeMock.start
  end

  after(:all) do
    StripeMock.stop
  end

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
    context 'successful api call' do
      it 'adds a stripe_id upon creation' do
        user = create(:user)
        expect(user.save).to be true
        expect(user.stripe_id).to_not be_nil
      end
    end

    context 'errored api call' do
      it 'prevents user creation' do
        stripe_error = Stripe::StripeError.new('Pretend stripe error')
        StripeMock.prepare_error(stripe_error, :new_customer)

        user = build(:user)
        expect(user.stripe_id).to be_nil
        expect(user.save).to be false
      end
    end
  end

  describe '#stripe_customer' do
    context 'successful api call' do
      it 'returns the stripe customer' do
        expect(create(:user).stripe_customer.class).to eq(Stripe::Customer)
      end
    end

    context 'errored api call' do
      it 'returns false' do
        stripe_error = Stripe::StripeError.new('Pretend stripe error')
        user = create(:user)
        StripeMock.prepare_error(stripe_error, :get_customer)
        expect(user.stripe_customer).to be false
      end
    end
  end

  # TODO: text new implementation of subscribe and cancel

  # describe '#select_starter_plan' do
  #   context 'user doesn\'t have a subscription yet' do
  #     it 'should set the users plan'
  #   end

  #   context 'user has an active subscription' do
  #     it 'should set the users plan'
  #     it 'should change the Stripe Subscription to the chosen plan'
  #   end

  #   context 'user has an in-active subscription' do
  #     it 'should subscribe the user to the plan'
  #     it 'should change the Stripe Subscription to the chosen plan'
  #   end
  # end

  # describe '#select_premium_plan' do
  #   context 'user doesn\'t have a subscription yet' do
  #     it 'should set the users plan'
  #   end

  #   context 'user has an active subscription' do
  #     it 'should set the users plan'
  #     it 'should change the Stripe Subscription to the chosen plan'
  #   end

  #   context 'user has an in-active subscription' do
  #     it 'should subscribe the user to the plan'
  #     it 'should change the Stripe Subscription to the chosen plan'
  #   end
  # end
end
