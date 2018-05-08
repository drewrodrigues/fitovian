require 'rails_helper'

RSpec.describe SelectionsController, type: :controller do
  let(:user) { create(:user, :onboarded) }
  let(:stack) { create(:stack) }

  it { is_expected.to use_before_action(:onboard_user!) }

  describe '#create' do
    before do
      sign_in user
    end

    context 'when stack doesn\'t exist' do
      before do
        post :create, params: { stack_id: 12381923719832 }
      end

      it { is_expected.to set_flash[:danger] }
    end

    context 'when user hasn\'t selected the stack' do
      before do
        post :create, params: { stack_id: stack }
      end

      it { is_expected.to set_flash[:success] }
    end

    context 'when user has selected the stack' do
      before do
        user.selections.create(stack: stack)
        post :create, params: { stack_id: stack }
      end

      it { is_expected.to set_flash[:success] }
    end
  end

  describe '#destroy' do
    before do
      sign_in user
    end

    context 'when stack doesn\'t exist' do
      before do
        delete :destroy, params: { stack_id: 2139018239817987 }
      end

      it { is_expected.to set_flash[:danger] }
    end

    context 'when user hasn\'t selected the stack' do
      before do
        delete :destroy, params: { stack_id: stack }
      end

      it { is_expected.to set_flash[:success] }
    end

    context 'when user has selected the stack' do
      before do
        user.selections.create(stack: stack)
        delete :destroy, params: { stack_id: stack }
      end

      it { is_expected.to set_flash[:success] }
    end
  end
end
