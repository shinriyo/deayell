class Api::OrdersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @orders = current_user.orders_json
     render json: @orders
  end

  def show
    @order = current_user.orders.find(:first,:conditions => ["id = ?", params[:id]])
     render json: @order.to_detail_json
  end

  def create

    order = current_user.orders.build({:order_detail => params[:order]})
    order.photo = current_user.photos.build(params[:photo])
    order.status_id = 1
    if order.save!
      render :json => {:success => true,:order => order}
    else
      render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
    end
  end
end
