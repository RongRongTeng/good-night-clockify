# frozen_string_literal: true

module RequestHelpers
  def authenticated_header(user)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end

  def json_body
    JSON.parse(response.body, symbolize_names: true)
  end
end
