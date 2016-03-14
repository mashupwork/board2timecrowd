Rails.application.config.middleware.use OmniAuth::Builder do
  provider :timecrowd, ENV['TIMECROWD_CLIENT_ID'], ENV['TIMECROWD_SECRET_KEY']
end
OmniAuth.config.logger = Rails.logger
