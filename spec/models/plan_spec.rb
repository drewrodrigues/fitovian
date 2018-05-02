require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:name) }
    it { is_expected.to have_db_column(:price) }
    it { is_expected.to have_db_column(:stripe_id) }
    it { is_expected.to have_db_column(:user_id) }
  end

  describe 'factories' do
    it 'has a valid starter_plan factory' do
      expect(build_stubbed(:starter_plan)).to be_valid
    end
  end
  
  describe 'validations' do
    context 'when name isn\'t correct' do
      it 'returns invalid' do
        plans = [ Plan::STARTER, Plan::TEST ]
        new_plan = Plan.new(user: build_stubbed(:user))

        plans.each do |plan|
          new_plan.name = 'something_is_wrong'
          new_plan.price = plan[:price]
          new_plan.stripe_id = plan[:stripe_id]
          expect(new_plan).to_not be_valid
        end
      end
    end

    context 'when stripe_id isn\'t correct' do
      it 'returns invalid' do
        plans = [ Plan::STARTER, Plan::TEST ]
        new_plan = Plan.new(user: build_stubbed(:user))

        plans.each do |plan|
          new_plan.name = plan[:name]
          new_plan.price = plan[:price]
          new_plan.stripe_id = 'something_is_wrong'
          expect(new_plan).to_not be_valid
        end
      end
    end

    context 'when price isn\'t correct' do
      it 'returns invalid' do
        plans = [ Plan::STARTER, Plan::TEST ]
        new_plan = Plan.new(user: build(:user))

        plans.each do |plan|
          new_plan.name = plan[:name]
          new_plan.price = -500
          new_plan.stripe_id = plan[:stripe_id]
          expect(new_plan).to_not be_valid
        end
      end
    end
  end
end