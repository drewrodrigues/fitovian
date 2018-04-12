require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  # TODO: ensure all errors are caught by controller
  before(:all) do
    StripeMock.start
    StripeMock.create_test_helper.create_plan(:id => 'starter', :amount => 1999)
  end

  after(:all) do
    StripeMock.stop
  end

  describe '#create' do
    before(:each) do
      # TODO: make helper methods, take these out of the model
      @user = create(:user)
      @user.select_starter_plan
      @user.add_fake_card
      sign_in(@user)
      post :create
    end

    context 'user subscribes' do
      it 'should add the subscription to the user' do
        expect(@user.subscription).to_not be_nil
      end

      it 'should respond with a successful message' do
        expect(flash[:success]).to eq("Successfully subscribed to #{@user.plan.name} plan")
      end

      it 'should redirect to billing' do
        expect(response).to redirect_to(billing_path)
      end

      it 'should set the Stripe subscription' do
        subscription = Stripe::Subscription.retrieve(@user.subscription.stripe_id)
        expect(subscription.status).to eq('active')
      end
    end
  end

  describe '#re_activate' do
    before(:each) do
      # TODO: make helper methods, take these out of the model
      @user = create(:user)
      @user.select_starter_plan
      @user.add_fake_card
      sign_in(@user)
    end

    context 'user is able to re_activate' do
      before(:each) do
        post :create
        put :re_activate
      end

      it 'should respond with a successful message' do
        expect(flash[:success]).to eq('Successfully re-activated membership')
      end

      it 'should redirect to billing' do
        expect(response).to redirect_to(billing_path)
      end

      it 'should update the users Stripe subscription' do
        subscription = Stripe::Subscription.retrieve(@user.subscription.stripe_id)
        expect(subscription.status).to eq('active')
        expect(subscription.cancel_at_period_end).to be false
      end
    end

    context 'user isn\'t able to re_activate' do
      before(:each) do
        put :re_activate
      end

      it 'should respond with a failed message' do
        expect(flash[:alert]).to eq('Failed to re-activate membership')
      end

      it 'should redirect to billing' do
        expect(response).to redirect_to(billing_path)
      end
    end
  end

  describe '#destroy' do
    before(:each) do
      # TODO: make helper methods, take these out of the model
      @user = create(:user)
      @user.select_starter_plan
      @user.add_fake_card
      sign_in(@user)
    end

    context 'user has an active subscription' do
      before(:each) do
        post :create
        delete :cancel
      end

      it 'should respond with a successful message' do
        expect(flash[:success]).to eq('Successfully canceled membership')
      end

      it 'should redirect to billing' do
        expect(response).to redirect_to(billing_path)
      end

      it 'should cancel the users Stripe subscription' do
        subscription = Stripe::Subscription.retrieve(@user.subscription.stripe_id)
        expect(subscription.status).to eq('active')
        expect(subscription.cancel_at_period_end).to be true
      end
    end

    context 'user doesn\'t have an active subscription' do
      before(:each) do
        delete :cancel
      end

      it 'should respond with a success message' do
        expect(flash[:success]).to eq('Successfully canceled membership')
      end

      it 'should redirect to billing' do
        expect(response).to redirect_to(billing_path)
      end
    end
  end
end
