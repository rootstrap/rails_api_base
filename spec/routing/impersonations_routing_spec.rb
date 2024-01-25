# frozen_string_literal: true

describe API::V1::ImpersonationsController do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/v1/impersonations/').to route_to('api/v1/impersonations#create', format: :json)
    end
  end
end
