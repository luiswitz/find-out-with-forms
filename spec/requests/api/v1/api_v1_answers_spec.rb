require 'rails_helper'

RSpec.describe "Api::V1::Answers", type: :request do
  describe '#index' do
    context 'with invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :get, '/api/v1/answers'
    end

  end
end
