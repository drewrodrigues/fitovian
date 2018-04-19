require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  # TODO: ensure all errors are caught by controller
  before(:all) do
    StripeMock.start
    StripeMock.create_test_helper.create_plan(:id => 'starter', :amount => 1999)
    StripeMock.create_test_helper.create_plan(:id => 'premium', :amount => 3999)
  end

  after(:all) do
    StripeMock.stop
  end

  describe '#create' do
    context 'successfully subscribed' do
      before(:each) do
        @user = create(:user)
        @user.select_starter_plan
        @user.add_fake_card
        sign_in(@user)
        post :create
      end

      it 'should respond with a successful message' do
        expect(flash[:success]).to eq("Successfully subscribed to #{@user.plan.name} plan")
      end

      it 'should redirect to billing' do
        expect(response).to redirect_to(billing_path)
      end
    end

    context 'duplicate subscribe' do
      before(:each) do
        @user = create(:user)
        @user.select_starter_plan
        @user.add_fake_card
        sign_in(@user)
        post :create
      end

      it 'should respond with a successful message' do
        expect(flash[:success]).to eq("Successfully subscribed to #{@user.plan.name} plan")
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

    context 'successfully canceled' do
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
    end

    context 'failed canceled' do
      before(:each) do
        delete :cancel
      end

      it 'should respond with a successful message' do
        expect(flash[:alert]).to eq('Failed to cancel membership')
      end

      it 'should redirect to billing' do
        expect(response).to redirect_to(billing_path)
      end
    end
  end
end
