require 'rails_helper'
require_relative '../helpers/cards_helper.rb'

RSpec.describe SubscriptionsController, type: :controller do
  include CardsHelper

  describe '#create' do
    context 'when successfully subscribed' do
      before do
        @user = create(:user)
        @user.select_starter_plan
        add_fake_card(@user)
        sign_in(@user)
        post :create
      end

      it 'responds with a successful message' do
        expect(flash[:success]).to eq(
          "Successfully subscribed to #{@user.plan.name} plan"
        )
      end

      it 'redirects to billing' do
        expect(response).to redirect_to(billing_path)
      end
    end

    context 'when duplicate subscribe' do
      before do
        @user = create(:user)
        @user.select_starter_plan
        add_fake_card(@user)
        sign_in(@user)
        post :create
      end

      it 'responds with a successful message' do
        expect(flash[:success]).to eq(
          "Successfully subscribed to #{@user.plan.name} plan"
        )
      end

      it 'redirects to billing' do
        expect(response).to redirect_to(billing_path)
      end
    end
  end

  describe '#destroy' do
    before do
      @user = create(:user)
      @user.select_starter_plan
      add_fake_card(@user)
      sign_in(@user)
    end

    context 'when successfully canceled' do
      before do
        post :create
        delete :cancel
      end

      it 'responds with a successful message' do
        expect(flash[:success]).to eq('Successfully canceled membership')
      end

      it 'redirects to billing' do
        expect(response).to redirect_to(billing_path)
      end
    end

    context 'when failed canceled' do
      before do
        delete :cancel
      end

      it 'responds with a successful message' do
        expect(flash[:alert]).to eq('Failed to cancel membership')
      end

      it 'redirects to billing' do
        expect(response).to redirect_to(billing_path)
      end
    end
  end
end
