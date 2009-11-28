require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "authlogic/test_case"
include Authlogic::TestCase

describe UserSessionsController do

  describe "User Session Actions" do
    before(:each) do
      @session_params = {:name=>"Test User", :email=>"test.user@mymapnow.com", :password=>"Esquilax1", :password_confirmation=>"Esquilax1"}
      activate_authlogic
    end
    
    def current_user(stubs = {})
      @current_user ||= mock_model(User, stubs)
    end

    def user_session(stubs = {}, user_stubs = {})
      @current_user ||= mock_model(UserSession, {:user => current_user(user_stubs)}.merge(stubs))
    end

    def login(session_stubs = {}, user_stubs = {})
      UserSession.stub!(:find).and_return(user_session(session_stubs, user_stubs))
    end

    def logout
      @user_session = nil
    end

    it "should create a new user session when hitting the new action" do
      get :new
      assigns[:user_session].should be_kind_of(UserSession)
    end

    it "should render the new user sessions template after hitting the new action" do
      get :new
      response.should render_template('new')
    end

    it "should redirect to new if no information is provided at session creation" do
      post :create, :user_session=>user_session
      response.should render_template('new')
    end
#
#    it "should log someone in and redirect them to the root url" do
#      UserSession.stub!(:new).and_return(user_session(:save=>true, :symbolize_keys=>{:name=>"me"}, :update=>false))
#      post :create, user_session
#      response.should redirect_to(root_url)
#    end

  end
end

