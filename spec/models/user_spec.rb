require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    let!(:user) { create(:user) }
    let!(:form) { create(:form, user: user) }

    it 'has many forms' do
      association = described_class.reflect_on_association(:forms)
      expect(association.macro).to eq(:has_many)
    end

    it 'deletes related forms' do
      user.destroy 
      expect(Form.where(user_id: user.id).count).to eq 0
    end
  end
end
