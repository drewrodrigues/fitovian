require 'rails_helper'

RSpec.describe CardHandler, type: :model do
  let(:stripe_helper) { StripeMock.create_test_helper }

  describe '#add' do
    context 'when User has no Cards' do
      it 'sets the card as the default' do
        user = create(:user)

        CardHandler.new(user).add(stripe_helper.generate_card_token)

        expect(user.default_card).to eq(user.cards.where(default: true).first)
      end

      it 'increments the User\'s cards' do
        user = create(:user)

        expect {
          CardHandler.new(user).add(stripe_helper.generate_card_token)
        }.to change(user.cards, :count).by(1)
      end

      it 'sets the default Stripe Card' do
        user = create(:user)

        CardHandler.new(user).add(stripe_helper.generate_card_token)

        expect(StripeHandler.new(user).default_card).to eq(user.default_card.stripe_id)
      end
    end

    context 'when User has multiple cards' do
      it 'increments the User\'s cards' do
        user = create(:user, :with_cards)

        expect {
          CardHandler.new(user).add(stripe_helper.generate_card_token)
        }.to change(user.cards, :count).by(1)
      end

      it 'sets the card as the default' do
        user = create(:user, :with_cards)

        CardHandler.new(user).add(stripe_helper.generate_card_token)

        expect(user.default_card).to eq(user.cards.where(default: true).first)
      end

      it 'is the only default card' do
        user = create(:user, :with_cards)

        CardHandler.new(user).add(stripe_helper.generate_card_token)

        expect(user.cards.where(default: true).count).to eq(1)
      end

      it 'sets the default Stripe Card' do
        user = create(:user)

        CardHandler.new(user).add(stripe_helper.generate_card_token)

        expect(
          StripeHandler.new(user).default_card
        ).to eq(user.default_card.stripe_id)
      end
    end

    context 'when Stripe errors' do
      it 'doesn\'t increment the User\'s cards' do
        user = create(:user)
        StripeMock.prepare_card_error(:card_declined, :create_source)

        expect {
          CardHandler.new(user).add(stripe_helper.generate_card_token)
        }.to_not change(user.cards, :count)
      end
    end
  end

  describe '#delete' do
    context 'when Card is default' do
      it 'returns false' do
        user = create(:user, :with_default_card)

        expect(CardHandler.new(user).delete(user.cards.last)).to be false
      end

      it 'doesn\'t decrement User\'s cards' do
        user = create(:user, :with_default_card)

        expect {
          CardHandler.new(user).delete(user.cards.last)
        }.to_not change(user.cards, :count)
      end

      it 'doesn\'t decrement User\'s Stripe cards' do
        user = create(:user, :with_default_card)

        expect {
          CardHandler.new(user).delete(user.cards.last)
        }.to_not change(StripeHandler.new(user), :card_count)
      end
    end

    context 'when Card isn\'t default' do
      it 'returns true' do
        user = create(:user, :with_card)

        expect(CardHandler.new(user).delete(user.cards.last)).to be_truthy
      end

      it 'decrements User\'s cards' do
        user = create(:user, :with_card)

        expect {
          CardHandler.new(user).delete(user.cards.last)
        }.to change(user.cards, :count).by(-1)
      end

      it 'decrements User\'s Stripe Cards' do
        user = create(:user, :with_card)

        expect {
          CardHandler.new(user).delete(user.cards.last)
        }.to change(StripeHandler.new(user), :card_count).by(-1)
      end
    end

    context 'when Stripe errors' do
      it 'returns false' do
        user = create(:user, :with_cards_one_default)
        StripeMock.prepare_card_error(:card_declined, :delete_source)

        expect(CardHandler.new(user).delete(user.cards.first)).to be_falsey
      end

      it 'doesn\'t decrement User\'s cards' do
        user = create(:user, :with_cards_one_default)
        StripeMock.prepare_card_error(:card_declined, :delete_source)

        expect {
          CardHandler.new(user).delete(user.cards.first)
        }.to_not change(user.cards, :count)
      end

      it 'doesn\'t decrement User\'s Stripe cards' do
        user = create(:user, :with_cards_one_default)
        StripeMock.prepare_card_error(:card_declined, :delete_source)

        expect {
          CardHandler.new(user).delete(user.cards.first)
        }.to_not change(StripeHandler.new(user), :card_count)
      end
    end
  end

  describe '#default' do
    context 'when User has 1 card' do
      it 'returns true' do
        user = create(:user, :with_card)

        expect(
          CardHandler.new(user).default(user.cards.first)
        ).to be_truthy
      end

      it 'sets 1 card to the default' do
        user = create(:user, :with_card)

        CardHandler.new(user).default(user.cards.first)

        expect(user.cards.where(default: true).count).to eq(1)
        expect(user.default_card).to be_truthy
      end
      it 'sets the default Stripe Card' do
        user = create(:user)

        CardHandler.new(user).add(stripe_helper.generate_card_token)
        CardHandler.new(user).add(stripe_helper.generate_card_token)

        expect(
          StripeHandler.new(user).default_card
        ).to eq(user.default_card.stripe_id)
      end
    end

    context 'when User has multiple cards' do
      it 'doesn\'t increment the User\'s default cards' do
        user = create(:user, :with_cards)

        CardHandler.new(user).default(user.cards.first)

        expect(user.cards.where(default: true).count).to eq(1)
      end

      it 'sets the last default card to default' do
        user = create(:user, :with_cards)

        CardHandler.new(user).default(user.cards.first)
        CardHandler.new(user).default(user.cards.last)

        expect(user.default_card).to eq(user.cards.last)
      end

      it 'sets the default Stripe Card' do
        user = create(:user)

        CardHandler.new(user).add(stripe_helper.generate_card_token)

        expect(
          StripeHandler.new(user).default_card
        ).to eq(user.default_card.stripe_id)
      end
    end

    context 'when User has multiple cards, where one is default' do
      it 'returns true' do
        user = create(:user, :with_cards_one_default)

        expect(CardHandler.new(user).default(user.cards.first)).to be_truthy
      end

      it 'only has one default card' do
        user = create(:user, :with_cards_one_default)

        CardHandler.new(user).default(user.cards.first)

        expect(user.cards.where(default: true).count).to eq(1)
      end

      it 'sets the default Stripe Card' do
        user = create(:user)

        CardHandler.new(user).add(stripe_helper.generate_card_token)

        expect(
          StripeHandler.new(user).default_card
        ).to eq(user.default_card.stripe_id)
      end
    end

    context 'when Stripe errors' do
      it 'returns false' do
        user = create(:user, :with_cards_one_default)
        StripeMock.prepare_card_error(:card_declined, :update_customer)

        expect(CardHandler.new(user).default(user.cards.first)).to be_falsey
      end

      it 'doesn\'t change the User\'s default Stripe card' do
        user = create(:user, :with_cards_one_default)
        StripeMock.prepare_card_error(:card_declined, :update_customer)

        expect {
          CardHandler.new(user).default(user.cards.first)
        }.to_not change(StripeHandler.new(user), :default_card)
      end

      it 'doesn\'t change the User\'s default card' do
        user = create(:user, :with_cards_one_default)
        StripeMock.prepare_card_error(:card_declined, :update_customer)

        expect {
          CardHandler.new(user).default(user.cards.first)
        }.to_not change(user, :default_card)
      end
    end
  end
end
