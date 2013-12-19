class Api::TravelController < TravelController
  respond_to :json
  before_filter :authenticate_user! ,:only => [:new, :edit ,:create, :update, :destroy, :map]

  def index
    if current_user
      render :json => {:travels =>current_user.travels.reorder('id DESC').map{|travel|travel.attributes.merge({:photo_url =>  travel.cover_photo.try(:image).try(:url) || nil})} , :user => current_user}
      return
    end
    render :json =>{:message => "no allow methods"}, :status => 422
  end


  def create
    travel = current_user.travels.build(params[:travel])
    if travel.save!
      render :json => {:success => true,:travel => travel}
    else
      render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
    end
  end
  def cover_photo
    super
    render :json => {:photo => @photo}

  end

  def map
    maps = current_user.travels.map{|travel| travel.gps}
    maps.delete(nil)
    render :json => {:travels => maps}

  end

end
