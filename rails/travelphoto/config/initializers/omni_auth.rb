require "omniauth-facebook"

Devise.setup do |config|
  if Rails.env.development?
    #config.omniauth :facebook, "156409037877921", "dcdb2887013ecd69baffb0e234edf501",{:scope => "email,read_friendlists,user_about_me"}
    app_id = "561769520578515"
    app_secret = "ce944074c0ebd5e417a6ca9f9814c033"
    config.omniauth :facebook, app_id, app_secret,{:scope => "email,read_friendlists,user_about_me"}
  end
  
end
