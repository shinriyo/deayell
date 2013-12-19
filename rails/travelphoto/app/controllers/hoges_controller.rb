class HogesController < ApplicationController
  # GET /hoges
  # GET /hoges.json
  def index
    @hoges = Hoge.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hoges }
    end
  end

  # GET /hoges/1
  # GET /hoges/1.json
  def show
    @hoge = Hoge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hoge }
    end
  end

  # GET /hoges/new
  # GET /hoges/new.json
  def new
    @hoge = Hoge.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hoge }
    end
  end

  # GET /hoges/1/edit
  def edit
    @hoge = Hoge.find(params[:id])
  end

  # POST /hoges
  # POST /hoges.json
  def create
    @hoge = Hoge.new(params[:hoge])

    respond_to do |format|
      if @hoge.save
        format.html { redirect_to @hoge, notice: 'Hoge was successfully created.' }
        format.json { render json: @hoge, status: :created, location: @hoge }
      else
        format.html { render action: "new" }
        format.json { render json: @hoge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hoges/1
  # PUT /hoges/1.json
  def update
    @hoge = Hoge.find(params[:id])

    respond_to do |format|
      if @hoge.update_attributes(params[:hoge])
        format.html { redirect_to @hoge, notice: 'Hoge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hoge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hoges/1
  # DELETE /hoges/1.json
  def destroy
    @hoge = Hoge.find(params[:id])
    @hoge.destroy

    respond_to do |format|
      format.html { redirect_to hoges_url }
      format.json { head :no_content }
    end
  end
end
