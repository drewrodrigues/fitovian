require 'rails_helper'

RSpec.describe StacksController, type: :controller do
  let(:user) { create(:user) }
  let(:stack) { create(:stack) }
  let(:lesson) { create(:lesson) }

  describe '#begin' do
    before do
      sign_in user
    end

    it 'increments Selections' do
      expect {
        post :begin, params: { id: stack.id }
      }.to change(Selection, :count).by(1)
    end

    context 'when there are no lessons' do
      it 'redirects to stack' do
        post :begin, params: { id: stack.id }
        expect(response).to redirect_to(stack)
      end
    end

    context 'when there are lessons' do
      it 'redirects to the first lesson' do
        post :begin, params: { id: lesson.stack.id }
        expect(response).to redirect_to(lesson.stack.lessons.first)
      end
    end
  end
end
