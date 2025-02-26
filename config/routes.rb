# frozen_string_literal: true

# == Route Map
#
#                                   Prefix Verb       URI Pattern                                                                                       Controller#Action
#                         new_user_session GET        /api/v1/users/sign_in(.:format)                                                                   api/v1/sessions#new
#                             user_session POST       /api/v1/users/sign_in(.:format)                                                                   api/v1/sessions#create
#                     destroy_user_session DELETE     /api/v1/users/sign_out(.:format)                                                                  api/v1/sessions#destroy
#                        new_user_password GET        /api/v1/users/password/new(.:format)                                                              api/v1/passwords#new
#                       edit_user_password GET        /api/v1/users/password/edit(.:format)                                                             api/v1/passwords#edit
#                            user_password PATCH      /api/v1/users/password(.:format)                                                                  api/v1/passwords#update
#                                          PUT        /api/v1/users/password(.:format)                                                                  api/v1/passwords#update
#                                          POST       /api/v1/users/password(.:format)                                                                  api/v1/passwords#create
#                 cancel_user_registration GET        /api/v1/users/cancel(.:format)                                                                    api/v1/registrations#cancel
#                    new_user_registration GET        /api/v1/users/sign_up(.:format)                                                                   api/v1/registrations#new
#                   edit_user_registration GET        /api/v1/users/edit(.:format)                                                                      api/v1/registrations#edit
#                        user_registration PATCH      /api/v1/users(.:format)                                                                           api/v1/registrations#update
#                                          PUT        /api/v1/users(.:format)                                                                           api/v1/registrations#update
#                                          DELETE     /api/v1/users(.:format)                                                                           api/v1/registrations#destroy
#                                          POST       /api/v1/users(.:format)                                                                           api/v1/registrations#create
#              api_v1_users_validate_token GET        /api/v1/users/validate_token(.:format)                                                            devise_token_auth/token_validations#validate_token
#                            api_v1_status GET        /api/v1/status(.:format)                                                                          api/v1/health#status {format: :json}
#                    api_v1_impersonations POST       /api/v1/impersonations(.:format)                                                                  api/v1/impersonations#create {format: :json}
#                              api_v1_user GET        /api/v1/user(.:format)                                                                            api/v1/users#show {format: :json}
#                                          PATCH      /api/v1/user(.:format)                                                                            api/v1/users#update {format: :json}
#                                          PUT        /api/v1/user(.:format)                                                                            api/v1/users#update {format: :json}
#              must_update_api_v1_settings GET        /api/v1/settings/must_update(.:format)                                                            api/v1/settings#must_update {format: :json}
#                   new_admin_user_session GET        /admin/login(.:format)                                                                            active_admin/devise/sessions#new
#                       admin_user_session POST       /admin/login(.:format)                                                                            active_admin/devise/sessions#create
#               destroy_admin_user_session DELETE|GET /admin/logout(.:format)                                                                           active_admin/devise/sessions#destroy
#                  new_admin_user_password GET        /admin/password/new(.:format)                                                                     active_admin/devise/passwords#new
#                 edit_admin_user_password GET        /admin/password/edit(.:format)                                                                    active_admin/devise/passwords#edit
#                      admin_user_password PATCH      /admin/password(.:format)                                                                         active_admin/devise/passwords#update
#                                          PUT        /admin/password(.:format)                                                                         active_admin/devise/passwords#update
#                                          POST       /admin/password(.:format)                                                                         active_admin/devise/passwords#create
#                               admin_root GET        /admin(.:format)                                                                                  admin/dashboard#index
#           batch_action_admin_admin_users POST       /admin/admin_users/batch_action(.:format)                                                         admin/admin_users#batch_action
#                        admin_admin_users GET        /admin/admin_users(.:format)                                                                      admin/admin_users#index
#                                          POST       /admin/admin_users(.:format)                                                                      admin/admin_users#create
#                     new_admin_admin_user GET        /admin/admin_users/new(.:format)                                                                  admin/admin_users#new
#                    edit_admin_admin_user GET        /admin/admin_users/:id/edit(.:format)                                                             admin/admin_users#edit
#                         admin_admin_user GET        /admin/admin_users/:id(.:format)                                                                  admin/admin_users#show
#                                          PATCH      /admin/admin_users/:id(.:format)                                                                  admin/admin_users#update
#                                          PUT        /admin/admin_users/:id(.:format)                                                                  admin/admin_users#update
#                                          DELETE     /admin/admin_users/:id(.:format)                                                                  admin/admin_users#destroy
#                          admin_dashboard GET        /admin/dashboard(.:format)                                                                        admin/dashboard#index
#                 batch_action_admin_users POST       /admin/users/batch_action(.:format)                                                               admin/users#batch_action
#                              admin_users GET        /admin/users(.:format)                                                                            admin/users#index
#                                          POST       /admin/users(.:format)                                                                            admin/users#create
#                           new_admin_user GET        /admin/users/new(.:format)                                                                        admin/users#new
#                          edit_admin_user GET        /admin/users/:id/edit(.:format)                                                                   admin/users#edit
#                               admin_user GET        /admin/users/:id(.:format)                                                                        admin/users#show
#                                          PATCH      /admin/users/:id(.:format)                                                                        admin/users#update
#                                          PUT        /admin/users/:id(.:format)                                                                        admin/users#update
#                                          DELETE     /admin/users/:id(.:format)                                                                        admin/users#destroy
#                           admin_comments GET        /admin/comments(.:format)                                                                         admin/comments#index
#                                          POST       /admin/comments(.:format)                                                                         admin/comments#create
#                            admin_comment GET        /admin/comments/:id(.:format)                                                                     admin/comments#show
#                                          DELETE     /admin/comments/:id(.:format)                                                                     admin/comments#destroy
#                                                     /admin/feature-flags                                                                              Flipper::UI
#                                 rswag_ui            /api-docs                                                                                         Rswag::Ui::Engine
#                                rswag_api            /api-docs                                                                                         Rswag::Api::Engine
#            rails_postmark_inbound_emails POST       /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#               rails_relay_inbound_emails POST       /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#            rails_sendgrid_inbound_emails POST       /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#      rails_mandrill_inbound_health_check GET        /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#            rails_mandrill_inbound_emails POST       /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#             rails_mailgun_inbound_emails POST       /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#           rails_conductor_inbound_emails GET        /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                          POST       /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#        new_rails_conductor_inbound_email GET        /rails/conductor/action_mailbox/inbound_emails/new(.:format)                                      rails/conductor/action_mailbox/inbound_emails#new
#            rails_conductor_inbound_email GET        /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
# new_rails_conductor_inbound_email_source GET        /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#    rails_conductor_inbound_email_sources POST       /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#    rails_conductor_inbound_email_reroute POST       /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
# rails_conductor_inbound_email_incinerate POST       /rails/conductor/action_mailbox/:inbound_email_id/incinerate(.:format)                            rails/conductor/action_mailbox/incinerates#create
#                       rails_service_blob GET        /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                 rails_service_blob_proxy GET        /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                          GET        /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                rails_blob_representation GET        /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#          rails_blob_representation_proxy GET        /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                          GET        /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                       rails_disk_service GET        /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                update_rails_disk_service PUT        /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                     rails_direct_uploads POST       /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create
#
# Routes for Rswag::Ui::Engine:
#
#
# Routes for Rswag::Api::Engine:

Rails.application.routes.draw do
  scope format: :json do
    mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
      registrations: 'api/v1/registrations',
      sessions: 'api/v1/sessions',
      passwords: 'api/v1/passwords'
    }
  end

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      get :status, to: 'health#status'
      resources :impersonations, only: %i[create], constraints: Impersonation::EnabledConstraint.new
      devise_scope :user do
        resource :user, only: %i[update show]
      end
      resources :settings, only: [] do
        get :must_update, on: :collection
      end
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :admin do
    authenticate(:admin_user) do
      mount Flipper::UI.app(Flipper) => '/feature-flags'
    end
  end

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
