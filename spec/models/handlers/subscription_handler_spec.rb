require 'rails_helper'

RSpec.describe SubscriptionHandler, type: :model do
  describe '#subscribe' do
    context 'when User doesn\'t have a stripe id' do
      it 'returns false' do
        user = create(:user)
        user.stripe_id = nil
        expect(SubscriptionHandler.new(user).subscribe).to be false
      end
    end

    context 'when user isn\'t subscribed' do
      it 'extends the users period_end to Stripe\'s end date' do
        user = create(:user, :with_card)
        SubscriptionHandler.new(user).subscribe

        expect(user.period_end).to eq(1.month.from_now.to_date)
      end

      it 'subscribes the user to the selected plan' do
        user = create(:user, :with_card)
        SubscriptionHandler.new(user).subscribe

        expect(
          StripeHandler.new(user).subscription.plan.id
        ).to eq(user.plan)
      end

      it 'increments the user\'s subscription by 1' do
        user = create(:user, :with_card)
        SubscriptionHandler.new(user).subscribe

        expect(StripeHandler.new(user).subscription_count).to eq(1)
      end
    end

    context 'when user is already subscribed' do
      it 'returns true' do
        user = create(:user, :with_card)
        handler = SubscriptionHandler.new(user)
        handler.subscribe

        expect(handler.subscribe).to be_truthy
      end

      it 'doesn\'t increment the users subscriptions' do
        user = create(:user, :with_card)
        handler = SubscriptionHandler.new(user)
        handler.subscribe

        expect(StripeHandler.new(user).subscription_count).to eq(1)
      end
    end

    context 'when user cancels existing subscription, then subscribes' do
      it 'doesn\'t increment the users subscriptions' do
        user = create(:user, :with_card)
        handler = SubscriptionHandler.new(user)
        handler.subscribe
        handler.cancel
        handler.subscribe

        expect(StripeHandler.new(user).subscription_count).to eq(1)
      end

      it 'won\'t cancel at period end' do
        user = create(:user, :with_card)
        handler = SubscriptionHandler.new(user)
        handler.subscribe
        handler.cancel
        handler.subscribe

        expect(
          StripeHandler.new(user).subscription.cancel_at_period_end
        ).to be false
      end
    end
  end

  describe '#cancel' do
    context 'when user isn\'t subscribed' do
      it 'returns true' do
        user = create(:user, :with_card)
        handler = SubscriptionHandler.new(user)

        expect(handler.cancel).to be true
      end
    end

    context 'when user is subscribed' do
      it 'cancels the user\'s Stripe subscription at period end' do
        user = create(:user, :with_card)
        handler = SubscriptionHandler.new(user)
        handler.subscribe
        handler.cancel

        expect(
          StripeHandler.new(user).subscription.cancel_at_period_end
        ).to be true
      end

      it 'returns true' do
        user = create(:user, :with_card)
        handler = SubscriptionHandler.new(user)
        handler.subscribe

        expect(handler.cancel).to be_truthy
      end
    end
  end
end