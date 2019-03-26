Devise.setup do |config|
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # devise
  config.secret_key = '6b098ea72ee90dea8c1609c6b4aa5bd57a374a0f44196fa239a5f406a6b3ddb681c4494960c38e8696aa8f29b66288a9a73a9ae2d638b576700a33a76fb222bd'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 11

  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..128

  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.reset_password_within = 6.hours

  config.sign_out_via = :delete

  config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], scope: 'email', redirect_uri: "#{Rails.application.secrets.host}/users/auth/google_oauth2/callback"

  config.omniauth :facebook, ENV['FACEBOOK_CLIENT_ID'], ENV['FACEBOOK_CLIENT_SECRET'], scope: 'email', info_fields: 'email', callback_url: "#{Rails.application.secrets.host}/users/auth/facebook/callback"
end
