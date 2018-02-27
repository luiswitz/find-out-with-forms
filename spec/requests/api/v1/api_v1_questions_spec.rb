require 'rails_helper'

RSpec.describe "Api::V1::Questions", type: :request do
  let(:user) { create(:user) }
  let(:form) { create(:form, user: user) }

  describe '#create' do
    context 'deny without authentication headers' do
      it_behaves_like :deny_without_authorization, :post, '/api/v1/questions'
    end

    context 'with valid parameters' do
      let(:question_attributes) { attributes_for(:question) }

      before do
        post '/api/v1/questions',
          params: { question: question_attributes, form_id: form.id },
          headers: header_with_authentication(user)
      end

      it 'return http code 200' do
        expect_status(200)
      end

      it 'is created with valid data' do
        question_attributes.each do |field|
          expect(Question.first[field.first.to_s]).to eq(field.last)
        end
      end

      it 'returns the correct data' do
        question_attributes.each do |field|
          expect(json[field.first.to_s]).to eq(field.last)
        end
      end
    end

    context 'with invalid parameters' do
      context 'valid form' do
        it 'returns http code 400' do
          post '/api/v1/questions',
            params: { question: {}, form_id: form.id },
            headers: header_with_authentication(user)

          expect_status(400)
        end
      end

      context 'invalid form' do
        it 'returns http code 404' do
          post '/api/v1/questions',
            params: { question: {} },
            headers: header_with_authentication(user)
          
          expect_status(404)
        end
      end
    end
  end

  describe '#update' do
    context 'with invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :put, '/api/v1/questions/0'
    end

    context 'with valid authentication headers' do
      context 'an existent question' do
        let(:question) { create(:question, form: form) }
        let(:question_attributes) { attributes_for(:question, id: question.id) }

        before do
          put "/api/v1/questions/#{question.id}",
            params: { question: question_attributes },
            headers: header_with_authentication(user)
        end

        it 'returns http code 200' do
          expect_status(200)
        end

        it 'creates a question with valid data' do
          question_attributes.each do |field|
            expect(Question.first[field.first]).to eq(field.last)
          end
        end

        it 'returns the correct data' do
          question_attributes.each do |field|
            expect(json[field.first.to_s]).to eq(field.las)
          end
        end
      end
    end
  end
end
