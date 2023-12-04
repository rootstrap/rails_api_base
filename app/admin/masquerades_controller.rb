# frozen_string_literal: true

class Admin::MasqueradesController < Devise::MasqueradesController
  def show
    super
  end

    protected

  def after_masquerade_path_for(resource)
    api_v1_home
  end

  def after_back_masquerade_path_for(resource)
    admin_root
  end

  def masquerade_authorize!
    true
    #authorize!(:masquerade, AdminUser)
  end

  def find_masqueradable_resource
    byebug
    masqueraded_resource_class.friendly.find(params[:id])
  end
end