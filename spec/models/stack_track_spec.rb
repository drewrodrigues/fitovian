require 'rails_helper'

RSpec.describe StackTrack, type: :model do
  let(:stack_track) { create(:stack_track) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:track) }
    it { is_expected.to validate_presence_of(:stack) }
  end

  describe 'factories' do
    it 'has a valid base factory' do
      expect(stack_track).to be_valid
    end
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:stack_id) }
    it { is_expected.to have_db_column(:track_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:stack) }
    it { is_expected.to belong_to(:track) }

    context 'when stack deleted' do
      before do
        stack_track.stack.destroy
      end

      it 'deletes the record' do
        expect { stack_track.reload }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'doesn\'t delete track' do
        expect(stack_track.track.persisted?).to be true
      end
    end

    context 'when track deleted' do
      before do
        stack_track.track.destroy
      end

      it 'deletes the record' do
        expect { stack_track.reload }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'doesn\'t delete stack' do
        expect(stack_track.stack.persisted?).to be true
      end
    end
  end
end
