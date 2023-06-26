# frozen_string_literal: true

json.status response.code
json.error  Rack::Utils::HTTP_STATUS_CODES[Rack::Utils.status_code(response.code)]
json.detail detail
