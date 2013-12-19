class Api::UsersController < ApplicationController
  def auth_facebook
    user = User.find_for_facebook_from_api(params, current_user)
    sign_in("user", user)
    unless user.authentication_token
      user.reset_authentication_token!
    end
    render :json=> {:success=>true, :auth_token=>user.authentication_token, :user_id => user.id, :email=>user.email}


  end
end
