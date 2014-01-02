class Api::RegistrationsController < ApplicationController
  # for "WARNING: Can't verify CSRF token authenticity"
  skip_before_filter :verify_authenticity_token

  respond_to :json
  def create
 
    user = User.new(params[:user])
    if user.save
      render :json=> user.as_json, :status=>201
      return
    else
      warden.custom_failure!
      render :json=> user.errors, :status=>422
    end
  end
end
