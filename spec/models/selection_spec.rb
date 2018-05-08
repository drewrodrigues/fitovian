require 'rails_helper'

RSpec.describe Selection, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:stack) }
    it { is_expected.to belong_to(:user) }

    context 'when stack is deleted' do
      it 'deletes the Selection' do
        selection = create(:selection)
        expect {
          selection.stack.destroy
        }.to change(Selection, :count).by(-1)
      end

      it 'doesn\'t delete the User' do
        selection = create(:selection)
        selection.stack.destroy
        expect {
          selection.user.reload
        }.to_not change(User, :count)
      end
    end

    context 'when user is deleted' do
      it 'deletes the Selection' do
        selection = create(:selection)
        expect {
          selection.user.destroy
        }.to change(Selection, :count).by(-1)
      end

      it 'doesn\'t delete the Stack' do
        selection = create(:selection)
        expect {
          selection.user.destroy
        }.to_not change(Stack, :count)
      end
    end
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:stack_id) }
    it { is_expected.to have_db_column(:user_id) }
  end

  describe 'factories' do
    it 'has a valid base factory' do
      expect(build_stubbed(:selection)).to be_valid
    end
  end

  describe 'validations' do
    let(:user) { create(:user) }
    let(:stack) { create(:stack) }

    it { is_expected.to validate_presence_of(:stack) }
    it { is_expected.to validate_presence_of(:user) }

    it 'doesn\'t allow user to have a duplicate stack' do
      user.selections.create(stack: stack)
      expect {
        user.selections.create(stack: stack)
      }.to_not change(Selection, :count)
    end

    it 'allows different users to have the same stack' do
      admin = create(:admin)
      user.selections.create(stack: stack)
      expect {
        admin.selections.create(stack: stack)
      }.to change(Selection, :count).by(1)
    end
  end
end
