# frozen_string_literal: true

module Admin
  class MasqueradesController < Devise::MasqueradesController
    protected

    def after_masquerade_path_for(_resource)
      '/api/v1/user'
    end

    def after_back_masquerade_path_for(_resource)
      '/admin'
    end

    def masquerade_authorize!
      true
      # authorize!(:masquerade, AdminUser)
    end
  end
end
