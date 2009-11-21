class ItemsController < ApplicationController
  def in_bounds
    southwest = params[:southwest].split(',').map(&:to_f)
    northeast = params[:northeast].split(',').map(&:to_f)
    begin_at = Time.parse(params[:start])
    end_at = Time.parse(params[:end])

    @items = Item.find_in_bounds(southwest, northeast, begin_at, end_at)

    respond_to do |format|
      format.js   { render :json => @items.to_json }
    end
  end

  def in_bounds_for_timeline
    southwest = params[:southwest].split(',').map(&:to_f)
    northeast = params[:northeast].split(',').map(&:to_f)
    begin_at = Time.parse(params[:start])
    end_at = Time.parse(params[:end])

    @items = Item.find_in_bounds(southwest, northeast, begin_at, end_at)

    the_json = "{ \"events\": ["
    @items.each do |item|
      the_json << "{"
      the_json << "\"start\": new Date(#{item.begin_at.year}, #{item.begin_at.month}, #{item.begin_at.day}, #{item.begin_at.hour}, #{item.begin_at.min}),"
      the_json << "\"end\": new Date(#{item.end_at.year}, #{item.end_at.month}, #{item.end_at.day}, #{item.end_at.hour}, #{item.end_at.min})," unless item.end_at.blank?
      the_json << "\"durationEvent\": #{!item.end_at.blank?},"
      escaped_title = item.title
      escaped_title = escaped_title.gsub('"', '\"')
      escaped_title = escaped_title.gsub(',', '\"')
      the_json << "\"title\": \"#{escaped_title}\""
      the_json << (item == @items.last ? "}" : "},")
    end
    the_json << "]}"

    respond_to do |format|
      format.js   { render :text => the_json  }
    end
  end

  # GET /items
  # GET /items.xml
  def index
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
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

    respond_to do |format|
      if @item.save
        flash[:notice] = 'Item was successfully created.'
        format.html { redirect_to(@item) }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
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
end
