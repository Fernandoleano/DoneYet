Rollbar.configure do |config|
  # Without configuration, Rollbar is enabled in all environments.
  # To disable in specific environments, set config.enabled=false.

  config.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]

  # Here we'll disable in 'test' and 'development' environments
  if Rails.env.test? || Rails.env.development?
    config.enabled = false
  end

  # By default, Rollbar will try to call the `current_user` controller method
  # to fetch the logged-in user object, and then call that object's `id`,
  # `username`, and `email` methods to fetch those property values. To customize:
  # config.person_method = "my_current_user"
  # config.person_id_method = "my_id"
  # config.person_username_method = "my_username"
  # config.person_email_method = "my_email"

  # If you want to attach user data to all errors, provide the method as above.
  # (It's enabled by default if 'current_user' is defined)

  # Add exception class names to the exception_level_filters hash to
  # change the level that exception is reported at. Note that if an exception
  # has already been reported and logged the level will need to be changed
  # via the rollbar interface.
  # Valid levels: 'critical', 'error', 'warning', 'info', 'debug', 'ignore'
  # 'ignore' will cause the exception to not be reported at all.
  # config.exception_level_filters.merge!('MyCriticalException' => 'critical')
  #
  # You can also specify a callable, which will be called with the exception instance.
  # config.exception_level_filters.merge!('MyCriticalException' => lambda { |e| 'critical' })

  # Enable asynchronous reporting (uses girl_friday or Sucker Punch if installed,
  # otherwise uses Thread)
  # config.use_async = true

  # Supply your own Async handler
  # config.async_handler = Proc.new { |payload|
  #  Thread.new { Rollbar.process_from_async_handler(payload) }
  # }

  # Enable sending logs to Rollbar
  # config.logger = Rails.logger
end
