class Api::SessionsController < DeviseController
  #include Devise::Controllers::Helpers #added
  before_filter :login_required, :except=>[:new, :create]  

  #before_filter :ensure_params_exist
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def create
    build_resource
    resource = User.find_for_database_authentication(:email => params[:user][:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])
      sign_in("user", resource) #TODO:

      resource.reset_authentication_token!
      render :json=> {:success=>true, :auth_token=>resource.authentication_token, :user_id => resource.id, :email=>resource.email}
      return
    end
    invalid_login_attempt
  end
  
  def destroy
    sign_out(resource_name)
  end
 
  protected
  def ensure_params_exist
    return unless params[:user_login].blank?
    render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
  end
 
  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end
end
