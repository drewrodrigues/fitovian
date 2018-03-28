require 'rails_helper'

RSpec.describe Card, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:last4) }
    it { is_expected.to validate_presence_of(:stripe_id) }
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'assocations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'database columns' do
    it { is_expected. to have_db_column(:default) }
    it { is_expected. to have_db_column(:last4) }
    it { is_expected. to have_db_column(:stripe_id) }
    it { is_expected. to have_db_column(:user_id) }
  end

  describe 'factories' do
    it 'has a valid base factory' do
      expect(build(:card)).to be_valid
    end
  end
end
