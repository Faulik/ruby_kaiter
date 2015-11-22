Rails.application.configure do
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :sendmail
end