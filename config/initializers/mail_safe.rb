# only used on staging

if defined?(MailSafe::Config)
  MailSafe::Config.internal_address_definition = /.*/i
  MailSafe::Config.replacement_address = 'charlie@enspiral.com'
end