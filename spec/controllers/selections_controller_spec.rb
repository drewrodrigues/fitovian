require 'rails_helper'

RSpec.describe SelectionsController, type: :controller do
  let(:user) { create(:user) }
  let(:course) { create(:course) }

  describe '#create' do
    before do
      sign_in user
    end

    context 'when course doesn\'t exist' do
      before do
        post :create, params: { course_id: 12381923719832 }
      end

      it { is_expected.to set_flash[:danger] }
    end

    context 'when user hasn\'t selected the course' do
      before do
        post :create, params: { course_id: course }
      end

      it { is_expected.to set_flash[:success] }
    end

    context 'when user has selected the course' do
      before do
        user.selections.create(course: course)
        post :create, params: { course_id: course }
      end

      it { is_expected.to set_flash[:success] }
    end
  end

  describe '#destroy' do
    before do
      sign_in user
    end

    context 'when course doesn\'t exist' do
      before do
        delete :destroy, params: { course_id: 2139018239817987 }
      end

      it { is_expected.to set_flash[:danger] }
    end

    context 'when user hasn\'t selected the course' do
      before do
        delete :destroy, params: { course_id: course }
      end

      it { is_expected.to set_flash[:success] }
    end

    context 'when user has selected the course' do
      before do
        user.selections.create(course: course)
        delete :destroy, params: { course_id: course }
      end

      it { is_expected.to set_flash[:success] }
    end
  end
end
