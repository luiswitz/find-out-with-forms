module Requests
  module JSONHelpers
    def expect_status(expected_status)
      expected(response.status).to eql(expected_status)
    end

    def json
      JSON.parse(response.body)
    end
  end

  module HeaderHelpers
    def header_with_authentication_user
      user.create_new_auth_token.merge({ 'HTTP_ACCEPT': 'application/json' })
    end

    def header_without_authentication
      { 'content-type' => 'application/json' }
    end
  end
end
