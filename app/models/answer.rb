class Answer < ApplicationRecord
  belongs_to :form
  has_many :questions_answers, dependent: :destroy

  validates :form, presence: true

  def self.create_with_questions(form, questions_answers) 
    answer = nil
    ActiveRecord::Base.transaction do
      answer = Answer.create(form: form)
      questions_answers.each do |question_answer|
        answer.questions_answers.create(question_answer.attributes)
      end
    end
    answer
  end
end
