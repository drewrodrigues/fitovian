require 'rails_helper'

RSpec.describe Track, type: :model do
  let(:track) { create(:track) }

  describe 'assocations' do
    it { is_expected.to have_many(:courses) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:title) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end
end
