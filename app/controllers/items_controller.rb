class ItemsController < ApplicationController
  # GET /items
  # GET /items.xml
  def index
    respond_to do |format|
      format.html { render :layout => 'application' }
      format.js do
        render :json => Item.find_in_bounds(params[:southwest].split(','), params[:northeast].split(','), Time.parse(params[:start]), Time.parse(params[:end])).to_json(:methods => [:body, :approved, :conversations], :except => [:description, :created_by, :approved_by])
      end
    end
  end

  # GET /items/1
  # GET /items/1.xml
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/new
  # GET /items/new.xml
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.xml
  def create
    @item = Item.new(params[:item])
    @item.created_by = request.remote_ip
    respond_to do |format|
      if @item.save
        flash[:notice] = 'Item was successfully created.'
        format.html { redirect_to root_path }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
        format.json { render :json => @item.to_json(:methods => [:body, :approved], :except => [:description, :created_by, :approved_by]) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = 'Item was successfully updated.'
        format.html { redirect_to(@item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(items_url) }
      format.xml  { head :ok }
    end
  end
  
  def approve
    @item = Item.find(params[:id])
    @item.approved_by = request.remote_ip

    respond_to do |format|
      if (@item.created_by != @item.approved_by) && @item.save
        flash[:notice] = 'Item was successfully approved.'
        format.html { redirect_to(@item) }
        format.xml  { head :ok }
        format.js   { head :ok }
      else
        flash[:notice] = 'You cannot approve this item.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
        format.js   { render :json => @item.errors, :status => :unprocessable_entity }
      end
    end
  end
end
