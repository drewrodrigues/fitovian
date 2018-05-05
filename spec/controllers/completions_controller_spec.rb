require 'rails_helper'

RSpec.describe CompletionsController, type: :controller do
  it { is_expected.to use_before_filter(:onboard_user!) }
  
  describe '#create' do
    let(:lesson) { create(:lesson) }
    let(:user) { create(:user, :onboarded) }

    context 'when user hasn\'t completed lesson' do
      before do
        sign_in user
        post :create, params: {resource_id: lesson.id, resource_type: Lesson}
      end

      it { is_expected.to set_flash[:success] }
      it { is_expected.to redirect_to(lesson) }
    end

    context 'when the user has completed the lesson' do
      before do
        sign_in user
        user.complete(lesson)        
        post :create, params: {resource_id: lesson.id, resource_type: Lesson}
      end

      it { is_expected.to set_flash[:success] }
      it { is_expected.to redirect_to(lesson) }
    end

    context 'with invalid params' do
      it 'raises an error' do
        sign_in user
        expect {
          post :create, params: {resource_id: 222, resource_type: Lesson}
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#destroy' do
    let(:lesson) { create(:lesson) }
    let(:user) { create(:user, :onboarded) }

    context 'when user hasn\'t completed lesson' do
      before do
        sign_in user
        delete :destroy, params: {resource_id: lesson.id, resource_type: Lesson}
      end

      it { is_expected.to set_flash[:warning] }
      it { is_expected.to redirect_to(lesson) }
    end

    context 'when the user has completed the lesson' do
      before do
        sign_in user
        user.complete(lesson)        
        delete :destroy, params: {resource_id: lesson.id, resource_type: Lesson}
      end
    end
  end
end
