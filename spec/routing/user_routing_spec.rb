require 'rails_helper'

describe Api::V1::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #update' do
      expect(put: '/api/v1/users/me').to route_to('api/v1/users#update', format: :json, id: 'me')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/users/me').to route_to('api/v1/users#show', format: :json, id: 'me')
    end
  end
end
