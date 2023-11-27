# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :email, :first_name, :last_name, :username, :password, :password_confirmation

  action_item :impersonate_user, only: :show do
    link_to 'Impersonate User', impersonate_admin_user_path(user), method: :post
  end

  action_item :stop_impersonating_user, only: :show do
    link_to 'Stop Impersonating User', stop_impersonating_admin_users_path, method: :post
  end

  member_action :impersonate, method: :post do
    impersonate_user(resource)
    redirect_to '/', notice: "Impersonated #{resource.email} successfully"
  end

  collection_action :stop_impersonating, method: :post do
    stop_impersonating_user
    redirect_to '/', notice: "Stopped impersonating successfully"
  end

  controller do
    def impersonate_userr(resource)
      raise ArgumentError, "No resource to impersonate" unless resource
      raise Pretender::Error, "Must be logged in to impersonate" unless true_user

      instance_variable_set(:"@impersonated_user", resource)
      # use to_s for Mongoid for BSON::ObjectId
      request.session[:"impersonated_user_id"] = resource.id.is_a?(Numeric) ? resource.id : resource.id.to_s
    end
  end

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
end
