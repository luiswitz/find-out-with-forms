require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'asssociations' do
    let!(:question) { create(:question) }
    let!(:question_answear) { create(:questions_answer, question: question) }

    it 'belongs to a form' do
      association = described_class.reflect_on_association(:form)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many questions_answears' do
      association = described_class.reflect_on_association(:questions_answers)
      expect(association.macro).to eq(:has_many)
    end

    it 'deletes all related questions_answears' do
      question.destroy
      expect(QuestionsAnswer.where(question_id: question.id).count).to eq 0
    end
  end

  describe 'validations' do
    let(:question) { build(:question) }

    it 'is not valid without a title' do
      question.title = nil
      expect(question).to_not be_valid
    end

    it 'is not valid without a kind' do
      question.kind = nil
      expect(question).to_not be_valid
    end

    it 'is not valid without a form' do
      question.form = nil
      expect(question).to_not be_valid
    end

    it 'has the right kinds' do
      expected_kinds = { 
        "short_text" => 0,
        "long_text" => 1,
        "integer" => 2, 
        "boolean" => 3
      }

      expect(described_class.kinds).to eq(expected_kinds)
    end
  end
end
