class Api::PhotoController < ApplicationController
  before_filter :authenticate_user! ,:only => [:new, :edit ,:create, :update, :destroy]
  respond_to :json
  def create
    return render :status => 422 unless current_user.travel_ids.include?(params[:photo][:travel_id].to_i)
    photo = current_user.travels.find_by_id(params[:photo][:travel_id]).albums.first.photos.new(:image => params[:photo][:image],:user => current_user)
    if photo.save!
      PhotoWorker.perform_async(photo.id)
      render :json => {:success => true}
    else
      render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
    end
    
 
  end

  def index
    return render :status => 422 unless params.has_key?(:travel_id)
    photos = Travel.find_by_id(params[:travel_id]).albums.first.photos
    render :json => {:photos => photos.map{|photo| photo.attributes.merge({:thumb_url => photo.image.url(:thumb), :image_url => photo.image.url, :travel_id => params[:travel_id]})}};
  end

end
