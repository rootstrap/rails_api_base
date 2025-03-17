# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::UsersController, type: :controller do
  describe '#update_user_params' do
    let(:controller) { described_class.new }

    context 'when first_name, last_name, and email are present in params' do
      it 'permits first_name, last_name, and email attributes' do
        # Set up the params with all permitted attributes
        controller.params = ActionController::Parameters.new(
          user: {
            first_name: 'John',
            last_name: 'Doe',
            email: 'john.doe@example.com'
          }
        )

        # Call the method
        result = controller.send(:update_user_params)

        # Verify that all permitted attributes are included
        expect(result.to_h).to eq(
          'first_name' => 'John',
          'last_name' => 'Doe',
          'email' => 'john.doe@example.com'
        )
      end
    end

    context 'when params include non-permitted attributes' do
      it 'excludes attributes not listed in the permitted parameters' do
        # Set up the params with both permitted and non-permitted attributes
        controller.params = ActionController::Parameters.new(
          user: {
            first_name: 'John',
            last_name: 'Doe',
            email: 'john.doe@example.com',
            username: 'johndoe',
            role: 'admin',
            created_at: Time.now
          }
        )

        # Call the method
        result = controller.send(:update_user_params)

        # Verify that only permitted attributes are included
        expect(result.to_h).to eq(
          'first_name' => 'John',
          'last_name' => 'Doe',
          'email' => 'john.doe@example.com'
        )

        # Verify that non-permitted attributes are excluded
        expect(result.to_h).not_to include('username')
        expect(result.to_h).not_to include('role')
        expect(result.to_h).not_to include('created_at')
      end
    end

    context 'when params do not contain a user key' do
      it 'raises an appropriate error' do
        # Set up params without a user key
        controller.params = ActionController::Parameters.new({})

        # Expect an error to be raised when the method is called
        expect {
          controller.send(:update_user_params)
        }.to raise_error(ActionController::ParameterMissing, /param is missing or the value is empty or invalid: user/)
      end
    end

    context 'when permitted parameters have empty string values' do
      it 'permits the parameters with their empty values' do
        # Set up the params with empty string values for all permitted attributes
        controller.params = ActionController::Parameters.new(
          user: {
            first_name: '',
            last_name: '',
            email: ''
          }
        )

        # Call the method
        result = controller.send(:update_user_params)

        # Verify that all permitted attributes are included with their empty values
        expect(result.to_h).to eq(
          'first_name' => '',
          'last_name' => '',
          'email' => ''
        )
      end
    end

    context 'when params include username attribute' do
      it 'excludes username from permitted parameters' do
        # Set up the params with username and other permitted attributes
        controller.params = ActionController::Parameters.new(
          user: {
            username: 'johndoe',
            first_name: 'John',
            last_name: 'Doe',
            email: 'john.doe@example.com'
          }
        )

        # Call the method
        result = controller.send(:update_user_params)

        # Verify that username is excluded from the permitted parameters
        expect(result.to_h).not_to include('username')
        expect(result.to_h).to eq(
          'first_name' => 'John',
          'last_name' => 'Doe',
          'email' => 'john.doe@example.com'
        )
      end
    end
  end
end

describe 'PUT api/v1/user/' do
  subject { put api_v1_user_path, params:, headers: auth_headers, as: :json }

  let(:user)             { create(:user) }
  let(:api_v1_user_path) { '/api/v1/user' }

  context 'when updating with valid permitted parameters' do
    let(:params) do
      {
        user: {
          first_name: 'New',
          last_name: 'Name',
          email: 'new.email@example.com'
        }
      }
    end

    before { subject }

    it 'returns success' do
      expect(response).to have_http_status(:success)
    end

    it 'updates the user first_name' do
      expect(user.reload.first_name).to eq(params[:user][:first_name])
    end

    it 'updates the user last_name' do
      expect(user.reload.last_name).to eq(params[:user][:last_name])
    end

    it 'updates the user email' do
      expect(user.reload.email).to eq(params[:user][:email])
    end

    it 'returns the user id' do
      expect(json[:user][:id]).to eq user.id
    end

    it 'returns the user full name' do
      expect(json[:user][:name]).to eq user.reload.full_name
    end
  end
end
