# -*- coding: utf-8 -*-
require 'spec_helper'

describe TravelController do
  include Devise::TestHelpers # to give your spec access to helpers
 
  before(:all) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    @different_user = FactoryGirl.create(:user)
    @different_user.confirm!
    FactoryGirl.create(:travel, :user => @user)
    10.times{FactoryGirl.create(:travel)}
  end
  
  describe "#index" do
    it "shows all data when user don't logged in" do
      travels = Travel.find(:all)
      get :index
      expect(assigns(:travels)).to match_array travels
    end
    it "show all data when user logged in" do
      sign_in :user, @user
      travels = Travel.find(:all)
      get :index
      expect(assigns(:travels)).to match_array travels
    end
    it "show user data when requested with user_id" do
      travels = Travel.find_all_by_user_id(@user.id)
      get :index,{:user_id => @user.id}
      expect(assigns(:travels)).to match_array travels
    end
  end


  describe "#show" do
    it "assigns the requested travel as @travel" do
      travel = Travel.find(:first)
      get :show, {:id => travel.id}
      expect(assigns(:travel)).to eq travel
    end
  end

  describe "#new" do
    it "access to new, does not work without a signed in user" do
      sign_out :user
      get :new
      response.should redirect_to(new_user_session_path)
    end
    it "assigns as new travel as @travel when sign in" do
      sign_in :user, @user
      get :new
      expect(assigns(:travel)).to be_a_new(Travel)
    end
  end

  describe "#edit" do
    it "access to edit, does not work without a signed in user" do
      sign_out :user
      travel = @user.travels.first
      get :edit,{ :id => travel.id}
      response.should redirect_to(new_user_session_path)
    end

    it "assign as edit travel as @travel when sign in" do
      sign_in :user, @user
      travel = @user.travels.first
      get :edit, {:id => travel.id}
      expect(assigns(:travel)).to eq travel
    end

    it "access to edit, does not work when sign in as another user" do
      sign_in :user, @different_user
      travel = @user.travels.first
      get :edit ,{:id => travel.id}
      response.should redirect_to(travel)
    end
  end
  

  before(:each) do 
    @travel_params = {:title => "タイトル" , :startdate => "2013-01-01", :enddate => "2013-12-31"}
  end

  describe "#POST create" do
    describe "without login" do
      it "should be redirect to login page" do
        sign_out :user
        post :create
        response.should redirect_to(new_user_session_path)
      end
    end
    describe "with login" do
      it " create new Travel" do
        sign_in :user,@user
        expect{
          post :create,:travel_params =>  @travel_params
        }.to change(Travel, :count).by(1)
      end

      it "create new travel as @travel" do
        sign_in :user,@user
        post :create, :travel_params =>  @travel_params
        expect(assigns(:travel)).to be_a(Travel)
      end

      it "doesn't create new travel with invaild params" do
        sign_in :user, @user
        Travel.any_instance.stub(:save).and_return(false)
        post :create, :travel_params =>  @travel_params
        expect(assigns(:travel)).to be_a_new(Travel)
      end


      it "doesn't create new travel with invaild params" do
        sign_in :user, @user
        Travel.any_instance.stub(:save).and_return(false)
        post :create, :travel_params =>  @travel_params
        expect(response).to render_template("new")
      end
    end
  end

  describe "#POST update" do
    describe "without login" do
      it "should be redirect to login page" do
        sign_out :user
        travel = @user.travels.first
        post :update,{:id =>  travel.id}
        response.should redirect_to(new_user_session_path)

      end
    end

    describe "another user" do
      it "should be redirect to another page" do
        sign_in :user, @different_user
        travel = @user.travels.first
        post :update,{:id =>  travel.id, :travel_params => @travel_params}
        response.should redirect_to(travel)
      end
    end

    describe "with vaild params" do
      it "assigns the requested travel as @travel" do
        sign_in :user, @user
        travel = @user.travels.first
        put :update, {:id => travel.id, :travel_params => @travel_params}
        assigns(:travel).should eq(travel)
      end

      it "redirects to the travel" do
        sign_in :user, @user
        travel = @user.travels.first
        put :update, {:id => travel.id,:travel_params =>  @travel_params}
        response.should redirect_to(travel)
      end
    end

    describe "with invalid params" do
      it "assigns the travel as @travel" do
        sign_in :user, @user
        travel = @user.travels.first
        Travel.any_instance.stub(:save).and_return(false)
        put :update, {:id => travel.id, :travel_params => @travel_params}
        expect(assigns(:travel)).to eq travel

      end

      it "re-renders the 'edit' template" do
        sign_in :user, @user
        travel = @user.travels.first
        Travel.any_instance.stub(:save).and_return(false)
        put :update, {:id => travel.id, :travel_params => @travel_params}
        expect(response).to render_template("edit")
      end
    end

  end
    
  describe "DELETE destroy" do
    describe "without login" do
      it "should be redirect to login page" do
        sign_out :user
        travel = @user.travels.first
        delete :update,{:id =>  travel.id}
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "another user" do
      it "should be redirect to another page" do
        sign_in :user, @different_user
        travel = @user.travels.first
        delete :update,{:id =>  travel.id}
        response.should redirect_to(travel)
      end
    end


    it "destroys the requested Travel" do
      sign_in :user, @user
      travel = @user.travels.first
      expect {
        delete :destroy, {:id => travel.id}
      }.to change(Travel, :count).by(-1)
    end
    
    it "redirects to the travels list" do
      sign_in :user, @user
      travel = FactoryGirl.create(:travel)
      delete :destroy, {:id => travel.id}
      response.should redirect_to(travel_url)
    end
  end

  before(:each) do 
    @travel = @user.travels.first
    @album = FactoryGirl.create(:album,:travel => @travel)
    @photo = FactoryGirl.create(:photo,:album => @album, :user => @user)
    @travel.cover_photo = @photo
    @travel.save
  end

  describe "GET cover_photo" do
    it "should be return cover_photo" do
      travel = @user.travels.first
      get :cover_photo, {:id => travel.id}
      expect(assigns(:photo)).to eq @photo
    end
  end

  describe "POST cover_photo" do
    it "access to cover_photo does not work without a signed in user" do
      sign_out :user
      post :cover_photo, {:id => @travel.id, :photo_id => @photo.id}
      response.should redirect_to(new_user_session_path)
    end

    it "access to edit, does not work when sign in as another user" do
      sign_in :user, @different_user
      post :cover_photo, {:id => @travel.id, :photo_id => @photo.id}
      response.should redirect_to(@travel)
    end

    it "should be set cover_photo" do
      sign_in :user, @user
      @travel.cover_photo = nil
      @travel.save
      post :cover_photo, {:id => @travel.id, :photo_id => @photo.id}
      expect(Travel.find(@travel.id).cover_photo.id).to eq @photo.id
    end

  end


end
