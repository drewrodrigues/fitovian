require 'rails_helper'

RSpec.describe SelectionHandler, type: :model do
  let(:user) { create(:user) }
  let(:stack) { create(:stack) }

  describe '#create' do
    context 'when stack doesn\'t exist' do
      it 'returns false' do
        expect(SelectionHandler.new(user, 12323).create).to be false
      end
    end

    context 'when user already selected stack' do
      it 'returns true' do
        SelectionHandler.new(user, stack.id).create
        expect(SelectionHandler.new(user, stack.id).create).to be_truthy
      end

      it 'doesn\'t increment Selections' do
        SelectionHandler.new(user, stack.id).create
        expect {
          SelectionHandler.new(user, stack.id).create
        }.to_not change(Selection, :count)
      end
    end

    context 'when user hasn\'t selected stack' do
      it 'returns truthy' do
        expect(SelectionHandler.new(user, stack.id).create).to be_truthy
      end

      it 'increments Selections by 1' do
        expect {
          SelectionHandler.new(user, stack.id).create
        }.to change(Selection, :count).by(1)
      end
    end
  end

  describe '#destroy' do
    context 'when stack doesn\'t exist' do
      it 'returns false' do
        expect(SelectionHandler.new(user, 123131).destroy).to be false
      end
    end

    context 'when user has selected stack' do
      it 'returns true' do
        SelectionHandler.new(user, stack.id).create
        expect(SelectionHandler.new(user, stack.id).destroy).to be_truthy
      end

      it 'decremenets Selection' do
        SelectionHandler.new(user, stack.id).create
        expect {
          SelectionHandler.new(user, stack.id).destroy
        }.to change(Selection, :count).by(-1)
      end
    end

    context 'when user hasn\'t selected stack' do
      it 'returns true' do
        expect(SelectionHandler.new(user, stack.id).destroy).to be_falsey
      end

      it 'doesn\'t decrement Selection' do
        expect {
          SelectionHandler.new(user, stack.id).destroy
        }.to_not change(Selection, :count)
      end
    end
  end
end
