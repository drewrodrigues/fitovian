require 'rails_helper'

RSpec.describe PlansController, type: :controller do
  describe 'Page Access' do
    context 'when signed in' do
      it 'renders the new template' do
        user = create(:user)
        sign_in(user)
        get :new
        expect(response).to render_template('new')
      end
    end

    context 'when signed out' do
      it 're-directs to the login page' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe '#create' do
    context 'when user doesn\'t have a plan yet' do
      before do
        @user = create(:user)
        sign_in(@user)
        post :create, params: { plan: 'starter' }
      end

      it 'responds with successful message upon create' do
        expect(flash[:success]).to eq('Successfully chose starter plan')
      end

      it 'redirects to new payment method' do
        expect(response).to redirect_to(new_cards_path)
      end
    end
  end
end
