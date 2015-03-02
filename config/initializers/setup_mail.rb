ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "gmail.com",
  :user_name => "serkanoran1234@gmail.com",
  :password => APP_CONFIG['pwd'],
  :authentication => "plain",
  :enable_starttls_auto => true
}
