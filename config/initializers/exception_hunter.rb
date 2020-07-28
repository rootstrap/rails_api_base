ExceptionHunter.setup do |config|
  # == Enabling
  #
  # This flag allows disabling error tracking, it's set to track in
  # any environment but development or test by default
  #
  config.enabled = !(Rails.env.development? || Rails.env.test?)

  # == Dashboard User
  # Exception Hunter allows you to restrict users who can see the dashboard
  # to the ones included in the database. You can change the table name in
  # case you are not satisfied with the default one. You can also remove the
  # configuration if you wish to have no access restrictions for the dashboard.
  #
  # config.admin_user_class = 'AdminUser'

  # == Current User
  #
  # Exception Hunter will include the user as part of the environment
  # data, if it was to be available. The default configuration uses devise
  # :current_user method. You can change it in case you named your user model
  # in some other way (i.e. Member). You can also remove the configuration if
  # you don't wish to track user data.
  #
  config.current_user_method = :current_user

  # == Current User Attributes
  #
  # Exception Hunter will try to include the attributes defined here
  # as part of the user information that is kept from the request.
  #
  config.user_attributes = %i[id email]

  # == Stale errors
  #
  # You can configure how long it takes for errors to go stale. This is
  # taken into account when purging old error messages but nothing will
  # happen automatically.
  #
  # config.errors_stale_time = 45.days
end
