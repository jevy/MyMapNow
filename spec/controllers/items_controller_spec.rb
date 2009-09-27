require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ItemsController do
  before(:each) do
    @valid_attributes = {
      :title => "Prime Minister's Residence",
      :begin_at => Time.mktime(1983, 3, 22, 15, 35, 0),
      :latitude => 45.444363,
      :longitude => -75.693811
    }
  end

  def mock_item(stubs={})
    @mock_item ||= mock_model(Item, stubs)
  end

  describe "get json for items within bounds" do
    it "should return the item as json" do
      items = mock('the items')
      items.should_receive(:to_json)
      Item.should_receive(:find_in_bounds).with([46.10848045950527,-60.24051439208984],
                                                [46.19148824417106,-60.09288560791015],
                                                Time.parse('2009-09-18 12:00'),
                                                Time.parse('2009-10-03 12:00')).and_return(items)

      get :index, {:format => 'js', "end"=>"2009-10-03 12:00", "northeast"=>"46.19148824417106,-60.09288560791015", "start"=>"2009-09-18 12:00", "southwest"=>"46.10848045950527,-60.24051439208984"}
    end
  end

  describe "GET index" do
    it "assigns all items as @items" do
      Item.stub!(:find).with(:all).and_return([mock_item])
      get :index
      assigns[:items].should == [mock_item]
    end
  end

  describe "GET show" do
    it "assigns the requested item as @item" do
      Item.stub!(:find).with("37").and_return(mock_item)
      get :show, :id => "37"
      assigns[:item].should equal(mock_item)
    end
  end

  describe "GET new" do
    it "assigns a new item as @item" do
      Item.stub!(:new).and_return(mock_item)
      get :new
      assigns[:item].should equal(mock_item)
    end
  end

  describe "GET edit" do
    it "assigns the requested item as @item" do
      Item.stub!(:find).with("37").and_return(mock_item)
      get :edit, :id => "37"
      assigns[:item].should equal(mock_item)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created item as @item" do
        Item.stub!(:new).with({'these' => 'params'}).and_return(mock_item(:save => true))
        post :create, :item => {:these => 'params'}
        assigns[:item].should equal(mock_item)
      end

      it "redirects to the created item" do
        Item.stub!(:new).and_return(mock_item(:save => true))
        post :create, :item => @valid_attributes # FIXME: this feels like a hack; was {}
        response.should redirect_to(item_url(mock_item))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved item as @item" do
        Item.stub!(:new).with({'these' => 'params'}).and_return(mock_item(:save => false))
        post :create, :item => {:these => 'params'}
        assigns[:item].should equal(mock_item)
      end

      it "re-renders the 'new' template" do
        Item.stub!(:new).and_return(mock_item(:save => false))
        post :create, :item => @valid_attributes # FIXME: this feels like a hack; was {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested item" do
        Item.should_receive(:find).with("37").and_return(mock_item)
        mock_item.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :item => {:these => 'params'}
      end

      it "assigns the requested item as @item" do
        Item.stub!(:find).and_return(mock_item(:update_attributes => true))
        put :update, :id => "1"
        assigns[:item].should equal(mock_item)
      end

      it "redirects to the item" do
        Item.stub!(:find).and_return(mock_item(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(item_url(mock_item))
      end
    end

    describe "with invalid params" do
      it "updates the requested item" do
        Item.should_receive(:find).with("37").and_return(mock_item)
        mock_item.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :item => {:these => 'params'}
      end

      it "assigns the item as @item" do
        Item.stub!(:find).and_return(mock_item(:update_attributes => false))
        put :update, :id => "1"
        assigns[:item].should equal(mock_item)
      end

      it "re-renders the 'edit' template" do
        Item.stub!(:find).and_return(mock_item(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested item" do
      Item.should_receive(:find).with("37").and_return(mock_item)
      mock_item.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the items list" do
      Item.stub!(:find).and_return(mock_item(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(items_url)
    end
  end

end
