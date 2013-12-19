class Api::FriendController < ApplicationController

  before_filter :authenticate_user!

def search
  users = params.has_key?(:username) ?  User.search_friends(params[:username]).delete_if{|user| user.id == current_user.id} : []
  render :json => {:users => users, :following_ids => current_user.following_ids}  
end

def search_facebook 
  users = params.has_key?(:uid) ? User.find_all_by_uid(params[:uid].split(",")).delete_if{|user| user.id == current_user.id} : []
  render :json => {:users => users, :following_ids => current_user.following_ids}  
end


def follow
  current_user.followings << User.find(params[:id])
  if current_user.save
    render :json => {:status => :success}
  else
    render :json => {:status => :error}
  end

end

end
