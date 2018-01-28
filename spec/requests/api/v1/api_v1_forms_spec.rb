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
      
      it 'returns http 200 code' do
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
end
