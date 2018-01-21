class Question < ApplicationRecord
  belongs_to :form
  has_many :questions_answers, dependent: :destroy
end
