require 'rails_helper'

RSpec.describe CourseTrack, type: :model do
  let(:course_track) { create(:course_track) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:track) }
    it { is_expected.to validate_presence_of(:course) }
  end

  describe 'factories' do
    it 'has a valid base factory' do
      expect(course_track).to be_valid
    end
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:course_id) }
    it { is_expected.to have_db_column(:track_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to belong_to(:track) }

    context 'when course deleted' do
      before do
        course_track.course.destroy
      end

      it 'deletes the record' do
        expect {
          course_track.reload
        }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'doesn\'t delete track' do
        expect(course_track.track.persisted?).to be true
      end
    end

    context 'when track deleted' do
      before do
        course_track.track.destroy
      end

      it 'deletes the record' do
        expect {
          course_track.reload
        }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'doesn\'t delete course' do
        expect(course_track.course.persisted?).to be true
      end
    end
  end
end
