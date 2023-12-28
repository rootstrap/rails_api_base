# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :email, :first_name, :last_name, :username, :password, :password_confirmation

  form do |f|
    f.inputs 'Details' do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :username

      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end

    actions
  end

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :username
    column :sign_in_count
    column :created_at
    column :updated_at

    actions
  end

  filter :id
  filter :email
  filter :username
  filter :first_name
  filter :last_name
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :username
      row :sign_in_count
      row :created_at
      row :updated_at
    end
  end

  action_item :impersonate_user, only: :show do
    params = {
      user_id: resource.id.to_s,
      admin_user_id: current_admin_user.id.to_s,
      expiry: 1.hour.from_now
    }.to_json
    len = ActiveSupport::MessageEncryptor.key_len
    salt = SecureRandom.hex(len)
    key = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    encrypted_data = crypt.encrypt_and_sign(params, purpose: 'impersonation')
    encrypted_data = Base64.urlsafe_encode64(encrypted_data)

    link_to('Impersonate User', "#{ENV.fetch('FRONTEND_URL')}?queryParams=#{salt}$$#{encrypted_data}", method: :get)
  end
end
