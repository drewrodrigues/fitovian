require 'rails_helper'

RSpec.describe StripeHandler, type: :model do
  describe '.set_stripe_id' do
    context 'when User doesn\'t have a Stripe ID yet' do
      it 'sets the users stripe_id' do
        user = build_stubbed(:user)
        expect(user.stripe_id).to be nil
        StripeHandler.set_stripe_id(user)
        expect(user.stripe_id).to_not be nil
      end

      it 'returns true' do
        user = build_stubbed(:user)
        expect(StripeHandler.set_stripe_id(user)).to be_truthy
      end
    end

    context 'when User already have a Stripe ID' do
      it 'doesn\'t change the current Stripe ID' do
        user = create(:user)
        current_id = user.stripe_id
        expect(user.stripe_id).to_not be nil
        StripeHandler.set_stripe_id(user)
        expect(user.stripe_id).to eq(current_id)
      end

      it 'returns true' do
        user = create(:user)
        expect(StripeHandler.set_stripe_id(user)).to be_truthy
      end
    end
  end

  describe '#customer' do
    it 'returns a Stripe::Customer' do
      user = create(:user)
      expect(StripeHandler.new(user).customer.class).to eq(Stripe::Customer)
    end
  end

  describe '#subscription' do
    context 'when user has a subscription' do
      it 'returns Stripe::Subscription' do
        user = create(:user, :with_card)
        SubscriptionHandler.new(user).subscribe
        expect(StripeHandler.new(user).subscription.class).to eq(Stripe::Subscription)
      end
    end

    context 'when user doesn\'t have a subscription' do
      it 'throws an error' do
        user = create(:user)
        expect { StripeHandler.new(user).subscription }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#subscription_count' do
    context 'when user is subscribed' do
      it 'returns 1' do
        user = create(:user, :with_card)
        SubscriptionHandler.new(user).subscribe
        expect(StripeHandler.new(user).subscription_count).to eq(1)
      end
    end

    context 'when user isn\'t subscribed' do
      it 'returns 0' do
        user = create(:user)
        expect(StripeHandler.new(user).subscription_count).to eq(0)
      end
    end
  end
end
