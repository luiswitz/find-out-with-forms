require 'rails_helper'

RSpec.describe QuestionsAnswer, type: :model do
  describe 'associations' do
    it 'belongs to an answer' do
      association = described_class.reflect_on_association(:answer)
      expect(association.macro).to eq(:belongs_to)
    end


    it 'belongs to a question' do
      association = described_class.reflect_on_association(:question)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    let(:question_answer) { build(:questions_answer) }

    it 'is not valid without a answer' do
      question_answer.answer = nil

      expect(question_answer).to_not be_valid
    end

    it 'is not valid without a question' do
      question_answer.question = nil

      expect(question_answer).to_not be_valid
    end
  end
end

