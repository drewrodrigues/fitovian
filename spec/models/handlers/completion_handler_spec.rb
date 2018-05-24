require 'rails_helper'

RSpec.describe CompletionHandler do
  let(:lesson) { create(:lesson) }
  let(:user) { create(:user) }

  describe '.complete?' do
    context 'when lesson complete' do
      it 'returns true' do
        CompletionHandler.complete(user, lesson)

        expect(CompletionHandler.complete?(user, lesson)).to be_truthy
      end
    end

    context 'when lesson not complete' do
      it 'returns true' do
        expect(CompletionHandler.complete?(user, lesson)).to be_falsy
      end
    end 
  end

  describe '.complete' do
    context 'when lesson already complete' do
      it 'returns true' do
        CompletionHandler.complete(user, lesson)

        expect(CompletionHandler.complete(user, lesson)).to be_truthy 
      end

      it 'marks the lesson as complete' do
        CompletionHandler.complete(user, lesson)
        expect(CompletionHandler.complete?(user, lesson)).to be_truthy
      end

      it 'doesn\'t allow duplicate records' do
        CompletionHandler.complete(user, lesson)

        expect {
          CompletionHandler.complete(user, lesson)
        }.to_not change(Completion, :count)
      end
    end

    context 'when lesson not complete' do
      it 'returns true' do
        expect(CompletionHandler.complete(user, lesson)).to be_truthy
      end

      it 'marks the lesson as complete' do
        CompletionHandler.complete(user, lesson)

        expect(CompletionHandler.complete?(user, lesson)).to be_truthy
      end
    end
  end

  describe '.incomplete' do
    context 'when lesson incomplete' do
      it 'returns true' do
        expect(CompletionHandler.incomplete(user, lesson)).to be_truthy
      end
    end
    
    context 'when lesson complete' do
      it 'returns true' do
        CompletionHandler.complete(user, lesson)

        expect(CompletionHandler.incomplete(user, lesson)).to be_truthy
      end

      it 'marks the lesson as incomplete' do
        CompletionHandler.complete(user, lesson)
        CompletionHandler.incomplete(user, lesson)

        expect(CompletionHandler.complete?(user, lesson)).to be_falsy
      end
    end
  end
end
