class PhotoController < ApplicationController
  def index
  end


  def create
    @photo = Photo.new(params[:photo])
    if @photo.save
      redirect_to @photo
    else
      render action: "new"
    end

  end

  def new
  end

  def show
  end

  def destroy
  end
end
