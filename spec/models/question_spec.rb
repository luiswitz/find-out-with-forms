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
end
