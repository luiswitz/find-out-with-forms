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

          it 'is updated with valid data' do
            form.reload
            form_attributes.each do |field|
              expect(json[field.first.to_s]).to eq(field.last)
            end
          end
        end

        context 'current user is not the owner' do
          let(:form) { create(:form) }
          let(:form_attributes) { attributes_for(:form, id: form.id) }

          before do
            put "/api/v1/forms/#{form.friendly_id}",
              params: { form: form_attributes },
              headers: header_with_authentication(user)
          end

          it 'returns 403' do
            expect_status(403)
          end
        end
      end

      context 'when the form does not exist' do
        let(:form_attributes) { attributes_for(:form) }

        it 'returnd http code 404' do
          put '/api/v1/forms/some-invalid-id',
            params: { form: form_attributes },
            headers: header_with_authentication(user)

          expect_status(404)
        end
      end
    end
  end

  describe '#create POST /forms' do
    let(:user) { create(:user) }

    context 'with invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :post, '/api/v1/forms'
    end

    context 'with valid authentication headers' do

      context 'with valid params' do
        let(:form_attributes) { attributes_for(:form) }

        before do
          post '/api/v1/forms',
            params: { form: form_attributes },
            headers: header_with_authentication(user)
        end

        it 'returns http code 200' do
          expect_status(200)
        end

        it 'is created with valid data' do
          form_attributes.each do |field|
            expect(Form.first[field.first]).to eq(field.last)
          end
        end
      end

      context 'with invalid params' do
        it 'returns http code 400' do
          post '/api/v1/forms',
            params: { form: {} },
            headers: header_with_authentication(user)

          expect_status(400)
        end
      end
    end
  end

  describe '#destroy DELETE /forms/:friendly_id' do
    let(:user) { create(:user) }

    context 'an existing form' do
      context 'current user is the owner' do
        let(:form) { create(:form, user: user) }

        before do
          delete "/api/v1/forms/#{form.friendly_id}",
            params: {},
            headers: header_with_authentication(user)
        end

        it 'returns http code 200' do
          expect_status(200)
        end

        it 'deletes the form' do
          expect(Form.all.count).to eq(0)
        end
      end

      context 'user is not the owner' do
        let(:form) { create(:form) }

        before do
          delete "/api/v1/forms/#{form.friendly_id}",
            params: {},
            headers: header_with_authentication(user)
        end

        it 'returns http code 403' do
          expect_status(403)
        end
      end
    end

    context 'a nonexistent form' do
      it  'returns http code 404' do
        delete "/api/v1/forms/something",
          params: {},
          headers: header_with_authentication(user)
        
        expect_status(404)
      end
    end
  end
end
