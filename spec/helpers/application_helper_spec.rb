require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "authlogic/test_case"
include Authlogic::TestCase

describe ApplicationHelper do

  before(:each) do
    @application_controller = ApplicationController.new
    @user = User.new(:email=>'user@test.ca', :password=>'test1', :password_confirmation=>'test1', :name=>'test')
    @user.save!
  end

  it "should return nil if no session is found" do
    activate_authlogic
    @application_controller.current_user_session.should be_nil
  end

  it "should return nil for the user if no sesison is created" do
    activate_authlogic
    @application_controller.current_user.should be_nil    
  end

  it "should allow user sesions to be created" do
    activate_authlogic
    u = UserSession.new(:email=>'user@test.ca', :password=>'test1')
    u.valid?.should be_true
  end

  it 'should return the user to the saved session' do
    activate_authlogic
    u = UserSession.new(:email=>'user@test.ca', :password=>'test1')
    u.save
    @application_controller.current_user.should eql(@user)
  end

  it "should not be able to match the persisted session from the original session" do
    activate_authlogic
    u = UserSession.new(:email=>'user@test.ca', :password=>'test1')
    u.save
    @application_controller.current_user_session.should_not eql(u)
  end

  after(:each) do
    @user.destroy
  end
end

