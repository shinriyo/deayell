class Api::UserDetailsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def create
    @user_detail = current_user.build_user_detail(params[:user_detail])
    
    respond_to do |format|
      if @user_detail.save
        format.json { render json: @user_detail, status: :created }
      else
        format.json { render json: @user_detail.errors, status: :unprocessable_entity }
      end
    end

  end

  def new
  end

  def edit
  end

  def show
    render :json => {:user_detail => current_user.user_detail}
  end

  def update
  end

  def destroy
  end
end
