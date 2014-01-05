class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  #protected

  #def after_inactive_sign_up_path_for(resource)
  #  signed_up_path
  #end

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if current_user
      redirect_to root_path
    elsif @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
