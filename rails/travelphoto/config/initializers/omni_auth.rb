require "omniauth-facebook"

Devise.setup do |config|
  if Rails.env.development?
    config.omniauth :facebook, "156409037877921", "dcdb2887013ecd69baffb0e234edf501",{:scope => "email,read_friendlists,user_about_me"}
  end
  
end
