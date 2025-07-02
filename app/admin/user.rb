# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :email, :first_name, :last_name, :username, :password, :password_confirmation

  if ENV['IMPERSONATION_URL'].present?
    member_action :impersonate, method: :post do
      signed_data = Impersonation::Verifier.new.sign!(
        user_id: resource.id, admin_user_id: current_admin_user.id
      )
      redirect_to "#{ENV.fetch('IMPERSONATION_URL')}?auth=#{signed_data}", allow_other_host: true
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

  if ENV['IMPERSONATION_URL'].present?
    action_item :user_impersonation, only: :show, if: proc { Flipper.enabled?(:impersonation_tool) } do
      link_to 'Impersonate User', impersonate_admin_user_path(resource), method: :post,
                                                                         target: '_blank', rel: 'noopener'
    end
  end
end
