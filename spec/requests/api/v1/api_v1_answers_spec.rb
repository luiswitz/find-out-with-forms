require 'rails_helper'

RSpec.describe "Api::V1::Answers", type: :request do
  let(:user) { create(:user) }
  let(:form) { create(:form, user: user) }

  describe '#index' do
    context 'with invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :get, '/api/v1/answers'
    end

    context 'with valid authentication headers' do
      context 'an existent answer' do
        let(:answer) { create(:answer, form: form) }
        let(:questions_answers_1) { create(:questions_answer, answer: answer) }
        let(:questions_answers_2) { create(:questions_answer, answer: answer) }

        before do
          get "/api/v1/answers/",
            params: {form_id: answer.form_id},
            headers: header_with_authentication(user)
        end

        it 'returns http code 200' do
          expect_status(200)
        end
      end
    end

  end
end
