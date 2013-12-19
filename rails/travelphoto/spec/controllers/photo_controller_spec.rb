require 'spec_helper'

describe PhotoController do
  include Devise::TestHelpers # to give your spec access to helpers

  before(:all) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    @different_user = FactoryGirl.create(:user)
    @different_user.confirm!
    FactoryGirl.create(:travel, :user => @user)
    @album = FactoryGirl.create(:album,:travel => @travel)

  end

  describe "#create" do
    it "creates with image and album" do
      sign_in :user, @user
      Photo.any_instance.stub(:save_attached_files).and_return(true)
      expect{
        post :create,{ :user_id => @user.id, :album_id => @album.id, :image => fixture_file_upload("/rails.png")}
      }.to change(Photo, :count).by(1)
      
    end 
  end
end
