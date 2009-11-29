require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "authlogic/test_case"
include Authlogic::TestCase

describe UsersController do

  before(:each) do
    @user_params = {:name=>"Test User", :email=>"test.user@mymapnow.com", :password=>"Esquilax1", :password_confirmation=>"Esquilax1"}
    activate_authlogic
  end

  def mock_user(stubs = {})
    @current_user ||= mock_model(User, stubs)
  end
  
  def user_session(stubs = {}, user_stubs = {})
    @current_user ||= mock_model(UserSession, {:user => mock_user(user_stubs)}.merge(stubs))
  end


  describe "new action" do

    it "should render the new template when invoked" do
      get :new
      response.should render_template('new')
    end

  end

  describe "create action" do
    it "should render the new view if no parameters are loaded" do
      post :create
      response.should render_template('new')
    end

    it "should redirect to user sessions/create when user is registered" do
      User.stub!(:new).and_return(mock_user(:save=>true))
      post :create, :user=>@user_params
      response.should redirect_to(:controller=>"user_sessions", :action=>"create")
    end

    it "should redirect to user sessions/create when valid user is registered" do
      User.stub!(:new).and_return(mock_user(:save=>true))
      post :create, :user=>@user_params
      response.should redirect_to(:controller=>"user_sessions", :action=>"create")
    end

    it "should render new template again when a user is not validated" do
      User.stub!(:new).and_return(mock_user(:save=>false))
      post :create, :user => @user_params
      response.should render_template(:new)
    end
    
    it "should have flash notices when successfully saving a user" do
      User.stub!(:new).and_return(mock_user(:save=>true))
      post :create, :user => @user_params
      flash[:notice].should eql("Account registered!")
    end
    
  end

  describe "update action" do

    #    it "should flash a notice when a user is updated" do
    #      UserSession.should_receive(:find).and_return(session)
    #      UsersController.should_receive(:current_user).and_return(mock_user(:update_attributes=>true))
    #      post :update, :user => @user_params
    #      flash[:notice].should eql("Account updated!!")
    #    end
    #
    #    it "should updates the requested user" do
    #
    #    end

  end
  
end

