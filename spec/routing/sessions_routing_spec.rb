describe Api::V1::SessionsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/v1/users/sign_in').to route_to('api/v1/sessions#create')
    end

    it 'routes to #destroy' do
      expect(delete: 'api/v1/users/sign_out').to route_to('api/v1/sessions#destroy')
    end
  end
end
