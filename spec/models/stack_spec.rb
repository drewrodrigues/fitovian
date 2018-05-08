require 'rails_helper'

RSpec.describe Stack, type: :model do
  let(:stack) { create(:stack) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'assocations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:lessons) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:tracks) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:category_id) }
    it { is_expected.to have_db_column(:title) }
  end
end