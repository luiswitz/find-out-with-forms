require 'rails_helper'

RSpec.describe Form, type: :model do
  describe 'assocaitions' do
    let!(:form) { create(:form) }
    let!(:question) { create(:question, form: form) }
    let!(:answear) { create(:answer, form: form) }

    it 'belongs to an user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many questions' do
      association = described_class.reflect_on_association(:questions)
      expect(association.macro).to eq(:has_many)
    end

    it 'deletes related questions' do
      form.destroy
      expect(Question.where(form_id: form.id).count).to eq 0
    end

    it 'has many answears' do
      association = described_class.reflect_on_association(:answers)  
      expect(association.macro).to be(:has_many)
    end

    it 'deletes related answears' do
      form.destroy 
      expect(Answer.where(form_id: form.id).count).to eq 0
    end
  end

  describe 'validations' do
    let(:form) { create(:form) } 

    it 'is not valid without a title' do
      form.title = nil 
      expect(form).to_not be_valid
    end

    it 'is not valid without a description' do
      form.description = nil
      expect(form).to_not be_valid
    end

    it 'is not valid without an user' do
      form.user = nil
      expect(form).to_not be_valid
    end

    it 'has a unique title' do
      created_title = form.title

      expect {
        create(:form, title: created_title)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
