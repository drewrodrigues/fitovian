require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:stacks) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:title) }
  end

  describe 'factories' do
    it 'has a valid base factory' do
      expect(build_stubbed(:category)).to be_valid
    end
  end
end
