shared_examples_for :deny_without_authorization do |method_type, action, params|
  it 'returns unauthorize 401 request' do
    Net::HTTP.call(
      method_type, 
      action, 
      params: params, 
      headers: header_without_authentication
    )

    expect(response.status).to eql(401)
  end
end
