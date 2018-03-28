require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:name) }
    it { is_expected.to have_db_column(:price) }
    it { is_expected.to have_db_column(:user_id) }
  end

  describe 'factories' do
    it 'has a valid base factory' do
      expect(build(:plan)).to be_valid
    end
  end

  describe '#is_valid_plans?' do
    context 'plan is valid' do
      it 'returns valid' do
        plan = build(:plan)
        expect(plan).to be_valid
      end
    end

    context 'plan isn\'t valid' do
      it 'returns invalid' do
        plan = build(:plan)
        plan.price = -20
        expect(plan).to_not be_valid
      end
    end
  end
end