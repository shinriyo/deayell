class TravelController < ApplicationController
  before_filter :authenticate_user! ,:only => [:new, :edit ,:create, :update, :destroy]


  def cover_photo
    @travel = Travel.find(params[:id])
    if params.has_key?(:photo_id) 
      return redirect_to new_user_session_path unless user_signed_in?
      return redirect_to travel_path(params[:id]) if @travel.user_id != current_user[:id] 
      @travel.cover_photo = Photo.find(params[:photo_id])
      @travel.save!
    else
      @photo = @travel.cover_photo
    end


  end

  def index
    if params.has_key?(:user_id)
      @travels = Travel.find_all_by_user_id(params[:user_id])
    else
      @travels = Travel.all
    end

#    respond_to do |format|
#      format.html # index.html.erb
#      format.json { render json: @hoges }
#    end

  end

  def create
    @travel = Travel.new(params[:travel])
    if @travel.save
      redirect_to @travel
    else
      render action: "new"
    end

  end

  def new
    @travel = Travel.new
  end

  def edit
    @travel = Travel.find(params[:id])
    return redirect_to travel_path(params[:id]) if @travel.user_id != current_user[:id]

  end

  def show
    @travel = Travel.find(params[:id])


  end

  def update
    @travel = Travel.find(params[:id])
    return redirect_to travel_path(params[:id]) if @travel.user_id != current_user[:id]
    
    if @travel.update_attributes(params[:travel])
      redirect_to @travel
    else
      render action: "edit"
    end


  end

  def destroy
    @travel = Travel.find(params[:id])
    @travel.destroy

    redirect_to travel_url 

  end
end
