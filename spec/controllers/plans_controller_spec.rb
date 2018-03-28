require 'rails_helper'

RSpec.describe PlansController, type: :controller do
  describe 'GET new' do
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
      end
    end
  end
end
