# frozen_string_literal: true

class Admin::MasqueradesController < Devise::MasqueradesController
  
  protected

  def after_masquerade_path_for(resource)
    '/api/v1/user'
  end

  def after_back_masquerade_path_for(resource)
    '/admin'
  end

  def masquerade_authorize!
    true
    #authorize!(:masquerade, AdminUser)
  end
end