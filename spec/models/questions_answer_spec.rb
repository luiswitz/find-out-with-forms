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
end

