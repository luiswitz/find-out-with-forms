require 'rails_helper'

RSpec.describe "Api::V1::Forms", type: :request do
  describe "GET /forms" do

    context 'with invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :get, '/api/v1/forms'
    end

    context 'with valid authentication headers' do
      let!(:user) { create(:user) }
      let!(:form1) { create(:form, user: user) }
      let!(:form2) { create(:form, user: user) }

      before do
        get '/api/v1/forms', params: {}, headers: header_with_authentication(user)
      end
      
      it 'returns http code 200' do
        expect_status(200)
      end

      it 'returns a list with two forms' do
        expect(json.count).to eq 2
      end

      it 'responds with expected data' do
        expect(json[0]).to eq(JSON.parse(form1.to_json))
        expect(json[1]).to eq(JSON.parse(form2.to_json))
      end
    end
  end

  describe 'GET /forms/:friendly_id' do
    let(:user) { create(:user) }

    context 'when form exists' do
      context 'and the form is enabled' do
        let!(:form) { create(:form, user: user, enable: true) }
        let!(:question1) { create(:question, form: form) }
        let!(:question2) { create(:question, form: form) }

        before do
          get "/api/v1/forms/#{form.friendly_id}", 
            params: {}, 
            headers: header_with_authentication(user)
        end

        it 'returns http code 200' do
          expect_status(200)
        end

        it 'returns expected form' do
          expect(json).to eq(JSON.parse(form.to_json(include: :questions)))
        end

        it 'returns associated questions' do
          expect(json['questions'].first).to eq(JSON.parse(question1.to_json))
          expect(json['questions'].last).to eq(JSON.parse(question2.to_json))
        end
      end

      context 'and is disabled' do
        let(:form) { create(:form, user: user, enable: false) }

        it 'returns http code 404' do
          get "/api/v1/forms/#{form.friendly_id}", 
            params: {}, 
            headers: header_with_authentication(user)

          expect_status(404)
        end
      end
    end

    context 'when the form doesn\'t exists' do
      it 'returns http code 404' do
        get '/api/v1/forms/something',
          params: {},
          headers: header_with_authentication(user)

        expect_status(404)
      end
    end
  end

  describe 'PUT /forms/:friendly_id' do
    context 'with invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :put, '/api/v1/forms/questionary'
    end

    context 'with valid authentication headers' do
      let(:user) { create(:user) }

      context 'when form exists' do
        context 'and current user is the owner' do
          let(:form) { create(:form, user: user) }
          let(:form_attributes) { attributes_for(:form, id: form.id) }

          before do
            put "/api/v1/forms/#{form.friendly_id}",
              params: { form: form_attributes },
              headers: header_with_authentication(user)
          end

          it 'returns http code 200' do
            expect_status(200)
          end

        end
      end
    end
  end
end
