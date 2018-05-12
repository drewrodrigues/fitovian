require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:cards) }
    it { is_expected.to have_many(:selections) }
    it { is_expected.to have_many(:stacks) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:admin) }
    it { is_expected.to have_db_column(:email) }
    it { is_expected.to have_db_column(:name) }
    it { is_expected.to have_db_column(:period_end) }
    it { is_expected.to have_db_column(:stripe_id) }
  end

  describe 'factories' do
    it 'has a valid base factory' do
      expect(build_stubbed(:user)).to be_valid
    end

    it 'has a valid admin factory' do
      expect(build_stubbed(:admin)).to be_valid
    end
  end
end
