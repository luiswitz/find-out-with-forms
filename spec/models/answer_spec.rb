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

  describe 'validations' do
    let(:answer) { build(:answer) }

    it 'is not valid without a form' do
      answer.form = nil  
      expect(answer).to_not be_valid
    end
  end

  describe '.create_with_questions' do
    let(:form) { create(:form) }

    let(:answer) { build(:answer, form: form) }
    let(:question_answer_1) { build(:questions_answer) }
    let(:question_answer_2) { build(:questions_answer) }

    let(:questions_answers) { [question_answer_1, question_answer_2] }

    before do
      @answer = described_class.create_with_questions(form, questions_answers)
    end

    it 'creates a associated form' do
      expect(@answer.form).to eq(form)
    end

    it 'creates associated questions_answers' do
      qa_1 = @answer.questions_answers.first
      qa_2 = @answer.questions_answers.last

      expect(qa_1.answer_id).to eq(@answer.id)
      expect(qa_1.question_id).to eq(question_answer_1.question_id)
      expect(qa_1.value).to eq(question_answer_1.value)

      expect(qa_2.answer_id).to eq(@answer.id)
      expect(qa_2.question_id).to eq(question_answer_2.question_id)
      expect(qa_2.value).to eq(question_answer_2.value)
    end

  end
end
