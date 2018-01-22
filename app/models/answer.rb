class Answer < ApplicationRecord
  belongs_to :form
  has_many :questions_answers, dependent: :destroy

  validates :form, presence: true
end
