
ActionMailer::Base.smtp_settings = {
  :address  => 'smtp.collectiveidea.com',
  :domain => 'collectiveidea.com',
  :port  => 587,
  :authentication => :plain,
  :user_name => 'app@collectiveidea.com',
  :password => 'kghlev75',
  :tls => true
}

ExceptionNotifier.exception_recipients = %w(code@collectiveidea.com)
ExceptionNotifier.email_prefix = "[mymapnow.com] "
ExceptionNotifier.sender_address = %("Application Error" <app@collectiveidea.com>)
