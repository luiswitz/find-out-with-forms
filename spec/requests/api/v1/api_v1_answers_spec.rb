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
        let!(:answer1) { create(:answer, form: form) }
        let!(:answer2) { create(:answer, form: form) }

        before do
          get "/api/v1/answers/",
            params: {form_id: form.id},
            headers: header_with_authentication(user)
        end

        it 'returns http code 200' do
          expect_status(200)
        end

        it 'returns a form list with 2 answers' do
          expect(json.count).to eq 2
        end

        it 'returns the right data' do
          expect(json[0]).to eq(JSON.parse(answer1.to_json))
          expect(json[1]).to eq(JSON.parse(answer2.to_json))
        end
      end
    end
  end

  describe '#show' do
    context 'with invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :get, '/api/v1/answers'
    end

    context 'with valid authentication headers' do
      context 'an existent answer' do
        let(:answer) { create(:answer, form: form) }
        let!(:questions_answers_1) { create(:questions_answer, answer_id: answer.id) }
        let!(:questions_answers_2) { create(:questions_answer, answer_id: answer.id) }

        before do
          get "/api/v1/answers/#{answer.id}",
            params: {},
            headers: header_with_authentication(user)
        end

        it 'returns http code 200' do
          expect_status(200)
        end

        it 'returns the right data' do
          expect(json.except('questions_answers')).to eq(JSON.parse(answer.to_json))
        end

        it 'returns related question_answers' do
          expect(json['questions_answers'].first).to eq(JSON.parse(questions_answers_1.to_json))
          expect(json['questions_answers'].last).to eq(JSON.parse(questions_answers_2.to_json))
        end
      end

      context 'a non existent answer' do
        it 'returns http code 404' do
          get '/api/v1/answers/something',
            params: {},
            headers: header_with_authentication(user)

          expect_status(404)
        end
      end
    end
  end

  describe '#create' do
    context 'when form has a valid id' do
      let(:question) { create(:question, form: form) }
      let(:questions_answers_1_attributes) { attributes_for(:questions_answer, question_id: question.id) }
      let(:questions_answers_2_attributes) { attributes_for(:questions_answer, question_id: question.id) }

      before do
        post '/api/v1/answers',
          params: {
            form: form,
            form_id: form.id,
            questions_answers: [
              questions_answers_1_attributes,
              questions_answers_2_attributes
            ]
          },
          headers: header_with_authentication(user)
      end

      it 'returns http code 200' do
        expect_status(200)
      end

      it 'answer are associated with the correct form' do
        expect(form).to eq(Answer.last.form)
      end

      it 'has associated questions_answers' do
        expect(json['id']).to eq(QuestionsAnswer.first.answer.id)
        expect(json['id']).to eq(QuestionsAnswer.last.answer.id)
      end
    end

    context 'with an invalid form id' do
      before do
        post '/api/v1/answers',
          params: { form_id: 0 },
          headers: header_with_authentication(user)
      end

      it 'returns 404' do
        expect_status(404)
      end
    end
  end

  describe '#destroy' do
    context 'with invalid authentication headers' do
      it_behaves_like :deny_without_authorization,
        :delete, '/api/v1/answers/0'
    end

    context 'with valid authentication headers' do
      context 'when answer exists' do
        context 'user is the owner' do
          let!(:answer) { create(:answer, form: form) }
          let!(:questions_answers) { create(:questions_answer, answer: answer) }

          before do
            delete "/api/v1/answers/#{answer.id}",
              params: {},
              headers: header_with_authentication(user)
          end

          it 'returns http code 200' do
            expect_status(200)
          end

          it 'deletes the answer' do
            expect(Answer.all.count).to eq 0
          end

          it 'deletes associated questions answers' do
            expect(QuestionsAnswer.all.count).to eq 0
          end

          it 'returns the ok message' do
            expect(json['message']).to eq('ok')
          end
        end

        context 'when user is not the owner' do
          let(:answer) { create(:answer) }

          before do
            delete "/api/v1/answers/#{answer.id}",
              params: {},
              headers: header_with_authentication(user)
          end

          it 'returns 403 http code' do
            expect_status(403)
          end
        end
      end

      context 'when answer does not exist' do
        it 'returns 404 http code' do
          delete '/api/v1/answers/something',
            params: {},
            headers: header_with_authentication(user)

          expect_status(404)
        end
      end
    end
  end
end
