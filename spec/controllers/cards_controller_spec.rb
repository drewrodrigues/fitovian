require 'rails_helper'

RSpec.describe CardsController, type: :controller do
  describe 'Page Access' do
    context 'Signed in' do
      it 'doesn\'t allow access when user doesn\'t have a plan' do
        user = create(:user)
        sign_in(user)
        get :new
        expect(response).to redirect_to(choose_plan_path)
      end

      it 'allows access once the user has a plan selected' do
        user = create(:starter_plan).user
        sign_in(user)
        get :new
        expect(response).to render_template('new')
      end
    end
  end

  describe '#create' do
    context 'user doesn\'t have a card yet' do
      before do
        token = StripeMock.create_test_helper.generate_card_token(last4: '1212')
        @user = create(:starter_plan).user
        sign_in(@user)
        post :create, params: { stripeToken: token }
      end
  
      it 'should respond with a successful message' do
        expect(flash[:success]).to eq('Successfully subscribed to starter plan')
      end
  
      it 'should redirect to lessons' do
        expect(response).to redirect_to(library_path)
      end
  
      it 'should add the card to the user' do
        expect(@user.cards.count).to eq(1)
      end
  
      it 'should be the user\'s default card' do
        expect(@user.default_card.last4).to eq('1212')
      end

      it 'should subscribe the user to the selected plan' do
        expect(@user.subscription).to_not be_nil
      end

      it 'should set the Stripe subscription' do
        subscription = Stripe::Subscription.retrieve(@user.subscription.stripe_id)
        expect(subscription.status).to eq('active')
      end
  
      it 'should add the card as the Stripe default' do
        stripe_default = Stripe::Customer.retrieve(@user.stripe_id).default_source
        expect(stripe_default).to eq(@user.default_card.stripe_id)
      end

      it 'should add the Stripe payment method' do
        stripe_cards = Stripe::Customer.retrieve(@user.stripe_id).sources.all(:object => "card")
        expect(stripe_cards.count).to eq(1)
      end
    end
  
    context 'user already has a card' do
      before do
        token = StripeMock.create_test_helper.generate_card_token(last4: '1111')
        token2 = StripeMock.create_test_helper.generate_card_token(last4: '2222')
        @user = create(:starter_plan).user
        sign_in(@user)
        post :create, params: { stripeToken: token }
        post :update, params: { stripeToken: token2 }
      end
  
      it 'should response with a successful message' do
        expect(flash[:success]).to eq('Successfully updated payment method')
      end
  
      it 'should redirect to billing' do
        expect(response).to redirect_to(billing_path)
      end
  
      it 'should add the card to the user' do
        expect(@user.cards.count).to eq(2)
      end
  
      it 'should update the most recent card to the default' do
        expect(@user.default_card.last4).to eq('2222')
      end
  
      it 'should add the card as the Stripe default' do
        stripe_default = Stripe::Customer.retrieve(@user.stripe_id).default_source
        expect(stripe_default).to eq(@user.default_card.stripe_id)
      end

      it 'should delete the Stripe payment method' do
        stripe_cards = Stripe::Customer.retrieve(@user.stripe_id).sources.all(:object => "card")
        expect(stripe_cards.count).to eq(2)
      end
    end
  end

  describe '#default' do
    before do
      token = StripeMock.create_test_helper.generate_card_token(last4: '1111')
      token2 = StripeMock.create_test_helper.generate_card_token(last4: '2222')
      @user = create(:starter_plan).user
      sign_in(@user)
      post :create, params: { stripeToken: token }
      post :update, params: { stripeToken: token2 }
    end

    context 'user sets the other card as the default' do
      before do
        put :default, params: { id: @user.cards.first.id }
      end

      it 'should respond with a successful message' do
        expect(flash[:success]).to eq('Successfully set default payment method')
      end

      it 'should redirect to billing' do
        expect(response).to redirect_to(billing_path)
      end

      it 'should change the user\'s default_card' do
        expect(@user.default_card.last4).to eq('1111')
      end

      it 'should update Stripe customers default payment method' do
        stripe_default = Stripe::Customer.retrieve(@user.stripe_id).default_source
        expect(stripe_default).to eq(@user.default_card.stripe_id)
      end
    end

    context 'user tries to set the current default as the default card' do
      before do
        put :default, params: { id: @user.default_card.id }
      end

      it 'should respond with a successful message' do
        expect(flash[:success]).to eq('Successfully set default payment method')
      end

      it 'should redirect to billing' do
        expect(response).to redirect_to(billing_path)
      end

      it 'should not change Stripe default payment method' do
        stripe_default = Stripe::Customer.retrieve(@user.stripe_id).default_source
        expect(stripe_default).to eq(@user.default_card.stripe_id)
      end
    end
  end

  describe '#destroy' do
    before do
      token = StripeMock.create_test_helper.generate_card_token(last4: '1111')
      token2 = StripeMock.create_test_helper.generate_card_token(last4: '2222')
      @user = create(:starter_plan).user
      sign_in(@user)
      post :create, params: { stripeToken: token }
      post :create, params: { stripeToken: token2 }
    end

    context 'user deletes the other card' do
      before do
        delete :destroy, params: { id: @user.cards.first }
      end

      it 'should respond with a successful message' do
        expect(flash[:success]).to eq('Successfully deleted payment method')
      end

      it 'should redirect to billing' do
        expect(response).to redirect_to(billing_path)
      end

      it 'should decrement the amount of cards' do
        expect(@user.cards.count).to eq(1)
      end

      it 'should delete the Stripe payment method' do
        stripe_cards = Stripe::Customer.retrieve(@user.stripe_id).sources.all(:object => "card")
        expect(stripe_cards.count).to eq(1)
      end
    end

    context 'user tries to delete the default card' do
      before do
        delete :destroy, params: { id: @user.default_card.id }
      end

      it 'should respond with a failed message' do
        expect(flash[:alert]).to eq('Failed to delete payment method')
      end

      it 'should redirect to billing' do
        expect(response).to redirect_to(billing_path)
      end

      it 'shouldn\'t change the amount of cards' do
        expect(@user.cards.count).to eq(2)
      end

      it 'shouldn\'t delete the Stripe payment method' do
        stripe_cards = Stripe::Customer.retrieve(@user.stripe_id).sources.all(:object => "card")
        expect(stripe_cards.count).to eq(2)
      end
    end
  end
end
