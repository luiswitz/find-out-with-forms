require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    let!(:answer) { create(:answer) }
    let!(:question_answer) { create(:questions_answer, answer: answer) }

    it 'belongs to a form' do
      association = described_class.reflect_on_association(:form)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many questions_answers' do
      association = described_class.reflect_on_association(:questions_answers)
      expect(association.macro).to eq(:has_many)
    end

    it 'destroy related questions_answers' do
      answer.destroy  
      expect(QuestionsAnswer.where(answer_id: answer.id).count).to eq 0
    end
  end
end
