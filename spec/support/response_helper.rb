# frozen_string_literal: true

module ResponseHelper
  def json_response
    JSON.parse(response.body)
  end

  def data
    json_response['data']
  end

  def attributes
    data['attributes'] || {}
  end

  def errors
    json_response['errors'].map { |error| error['detail'] }
  end
end
