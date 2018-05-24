require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:lesson) { create(:lesson) }

  describe '#begin' do
    before do
      sign_in user
    end

    it 'increments Selections' do
      expect {
        post :begin, params: { id: course.id }
      }.to change(Selection, :count).by(1)
    end

    context 'when there are no lessons' do
      it 'redirects to course' do
        post :begin, params: { id: course.id }
        expect(response).to redirect_to(course)
      end
    end

    context 'when there are lessons' do
      it 'redirects to the first lesson' do
        post :begin, params: { id: lesson.course.id }
        expect(response).to redirect_to(lesson.course.lessons.first)
      end
    end
  end
end
