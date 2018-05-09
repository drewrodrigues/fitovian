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
  end

  describe '#subscribe' do
    context 'when user doesn\'t have a subscription' do
      let(:user) { create(:user, :with_plan_and_card) }

      before { user.subscribe }

      it 'adds the subscription to the user' do
        expect(user.subscription).to_not be_nil
      end

      it 'subscribes the user to the plan' do
        stripe_subscription = user.subscription.stripe_subscription
        expect(stripe_subscription.customer).to eq(user.stripe_id)
      end

      it 'sets the user\'s subscription to active' do
        expect(user.subscription.active).to be true
      end

      it 'sets the user\'s Stripe subscription status to active' do
        subscription = user.subscription.stripe_subscription
        expect(subscription.status).to eq('active')
      end

      it 'sets the current_period_end 1 month out' do
        subscription = user.subscription
        expect(subscription.current_period_end).to eq(Time.zone.today + 1.month)
      end

      it 'has 1 stripe subscription' do
        subscription_count = Stripe::Customer.retrieve(user.stripe_id)
                                             .subscriptions.total_count
        expect(subscription_count).to eq(1)
      end
    end

    context 'when user already has an active subscription' do
      let(:user) { create(:user, :onboarded) }

      before { user.subscribe }

      it 'returns true' do
        expect(user.subscription.subscribe).to be true
      end

      it 'prevents duplicate subscriptions' do
        subscription_count = Stripe::Customer.retrieve(user.stripe_id)
                                             .subscriptions.total_count
        expect(subscription_count).to eq(1)
      end
    end

    context 'when user has an in-active subscription' do
      let(:user) { create(:user, :onboarded) }

      before { user.cancel }

      it 'returns true' do
        expect(user.subscription).to be_truthy
      end

      it 'prevents duplicate subscriptions' do
        subscription_count = Stripe::Customer.retrieve(user.stripe_id)
                                             .subscriptions.total_count
        expect(subscription_count).to eq(1)
      end
    end
  end

  describe '#cancel' do
    context 'when user doesn\'t have a subscription' do
      let(:user) { create(:user, :onboarded) }

      before { user.cancel }

      it 'sets to cancel at period end' do
        subscription = user.subscription.stripe_subscription
        expect(subscription.cancel_at_period_end).to be true
      end

      it 'sets active to false' do
        expect(user.subscription.active).to be false
      end

      it 'sets status to canceled' do
        subscription = user.subscription
        expect(subscription.status).to eq('canceled')
      end
    end

    context 'when user\'s subscription is already canceled' do
      let(:user) { create(:user, :onboarded) }

      before { user.cancel }

      it 'sets to cancel at period end' do
        subscription = user.subscription.stripe_subscription
        expect(subscription.cancel_at_period_end).to be true
      end

      it 'sets active to false' do
        expect(user.subscription.active).to be false
      end

      it 'sets status to canceled' do
        subscription = user.subscription
        expect(subscription.status).to eq('canceled')
      end
    end
  end
end
