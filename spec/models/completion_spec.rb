require 'rails_helper'

RSpec.describe Completion, type: :model do
  describe 'assocations' do
    it { is_expected.to belong_to(:completable) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:completable_id) }
    it { is_expected.to have_db_column(:completable_type) }
    it { is_expected.to have_db_column(:user_id) }
  end

  describe 'factories' do
    it 'has a valid base factory' do
      completion = create(:completion)
      expect(completion).to be_valid
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:completable_id) }
    it { is_expected.to validate_presence_of(:completable_type) }
    it { is_expected.to validate_presence_of(:user) }

    it 'should not allow duplicate records' do
      first_record = create(:completion)
      duplicate_record = first_record.dup
      duplicate_record.user_id = first_record.user_id
      expect{ duplicate_record.save }.to_not change(Completion, :count)
    end
  end
end

