require 'rails_helper'

RSpec.describe Selection, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to belong_to(:user) }

    context 'when course is deleted' do
      it 'deletes the Selection' do
        selection = create(:selection)
        expect {
          selection.course.destroy
        }.to change(Selection, :count).by(-1)
      end

      it 'doesn\'t delete the User' do
        selection = create(:selection)
        selection.course.destroy
        expect {
          selection.user.reload
        }.to_not change(User, :count)
      end
    end

    context 'when user is deleted' do
      it 'deletes the Selection' do
        selection = create(:selection)
        expect {
          selection.user.destroy
        }.to change(Selection, :count).by(-1)
      end

      it 'doesn\'t delete the Course' do
        selection = create(:selection)
        expect {
          selection.user.destroy
        }.to_not change(Course, :count)
      end
    end
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:course_id) }
    it { is_expected.to have_db_column(:user_id) }
  end

  describe 'factories' do
    it 'has a valid base factory' do
      expect(build_stubbed(:selection)).to be_valid
    end
  end

  describe 'validations' do
    let(:user) { create(:user) }
    let(:course) { create(:course) }

    it { is_expected.to validate_presence_of(:course) }
    it { is_expected.to validate_presence_of(:user) }

    it 'doesn\'t allow user to have a duplicate course' do
      user.selections.create(course: course)
      expect {
        user.selections.create(course: course)
      }.to_not change(Selection, :count)
    end

    it 'allows different users to have the same course' do
      admin = create(:admin)
      user.selections.create(course: course)
      expect {
        admin.selections.create(course: course)
      }.to change(Selection, :count).by(1)
    end
  end
end
