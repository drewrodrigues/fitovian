require 'rails_helper'

RSpec.describe PlansController, type: :controller do
  # TODO: double check stripe that the information is updated correctly, once subscription is implemented
  
  before(:all) do
    StripeMock.start
  end

  after(:all) do
    StripeMock.stop
  end

  describe 'Page Access' do
    context 'signed in' do
      it 'renders the new template' do
        user = create(:user)
        sign_in(user)
        get :new
        expect(response).to render_template('new')
      end
    end

    context 'signed out' do
      it 're-directs to the login page' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context 'user doesn\'t have a plan yet' do
    before(:each) do
      @user = create(:user)
      sign_in(@user)
      post :create, params: { plan: Plan::STARTER[:name] }
    end

    it 'responds with successful message upon create' do
      expect(flash[:success]).to eq('Successfully chose starter plan')
    end

    it 'redirects to new payment method' do
      expect(response).to redirect_to(new_cards_path)
    end

    it 'adds the plan to the user' do
      expect(@user.reload.plan.name).to eq('starter')
    end
  end

  describe '#create' do
    context 'user already has a plan' do
      before(:each) do
        @user = create(:starter_plan).user
        sign_in(@user)
        expect(@user.plan.name).to eq('starter')
        post :create, params: { plan: Plan::PREMIUM[:name] }
      end

      it 'responds with successful message' do
        expect(flash[:success]).to eq('Successfully chose premium plan')
      end

      it 'redirects to new payment method' do
        expect(response).to redirect_to(billing_path)
      end

      it 'changes the user\'s plan' do
        expect(@user.reload.plan.name).to eq('premium')
      end
    end
  end
end
