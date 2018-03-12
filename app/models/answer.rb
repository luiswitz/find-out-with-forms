class Answer < ApplicationRecord
  belongs_to :form
  has_many :questions_answers, dependent: :destroy

  validates :form, presence: true

  def self.create_with_questions(form, question_answers) 
    ActiveRecord::Base.transaction do
      answer = Answer.create(form: form)
    end
  end
end
