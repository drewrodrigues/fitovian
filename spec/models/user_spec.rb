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

    it 'has a valid user_with_card factory' do
      expect(build_stubbed(:user_with_card)).to be_valid
    end

    it 'has a valid user_with_cards factory' do
      expect(build_stubbed(:user_with_cards)).to be_valid
    end
  end

  describe '#set_stripe_id' do
    context 'successful api call' do
      it 'adds a stripe_id upon creation' do
        user = build(:user)
        user.stripe_id = nil
        expect(user.stripe_id).to be_nil
        expect(user.save).to be true
        expect(user.stripe_id).to_not be_nil
      end
    end

    context 'errored api call' do
      it 'prevents user creation' do
        StripeMock.start
        stripe_error = Stripe::StripeError.new('Pretend stripe error')
        StripeMock.prepare_error(stripe_error, :new_customer)

        user = build(:user)
        expect(user.stripe_id).to be_nil
        expect(user.save).to be false

        StripeMock.stop
      end
    end
  end

  describe '#stripe_customer' do
    context 'successful api call' do
      it 'returns the stripe customer' do
        StripeMock.start
        expect(create(:user).stripe_customer.class).to eq(Stripe::Customer)
        StripeMock.stop
      end
    end

    context 'errored api call' do
      it 'returns false' do
        StripeMock.start
        stripe_error = Stripe::StripeError.new('Pretend stripe error')

        user = create(:user)
        StripeMock.prepare_error(stripe_error, :get_customer)
        expect(user.stripe_customer).to be false

        StripeMock.stop
      end
    end
  end

  describe '#default_payment_method' do
    context 'user has 1 payment method' do
      it 'returns the default payment method' do
        StripeMock.start
        user = create(:user_with_card)
        expect(user.default_payment_method).to eq(user.cards.first)
        StripeMock.stop
      end
    end

    context 'user has multiple payment methods' do
      it 'should only have 1 card with default set to true' do
        StripeMock.start
        user = create(:user_with_cards)
        expect(user.cards.where(default: true).count).to eq(1)
        StripeMock.stop
      end

      it 'returns the default payment method' do
        StripeMock.start
        user = create(:user_with_cards)
        expect(user.default_payment_method.default).to be true
        StripeMock.stop
      end
    end

    context 'user doesn\'t have a payment method' do
      it 'returns nil' do
        user = build_stubbed(:user)
        expect(user.default_payment_method).to be_nil
      end
    end
  end
end
