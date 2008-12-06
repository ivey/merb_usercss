require File.dirname(__FILE__) + '/../spec_helper'

describe "MerbUsercss::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { add_slice(:MerbUsercss) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(MerbUsercss::Main, :index)
    controller.slice.should == MerbUsercss
    controller.slice.should == MerbUsercss::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(MerbUsercss::Main, :index)
    controller.status.should == 200
    controller.body.should contain('MerbUsercss')
  end
  
  it "should work with the default route" do
    controller = get("/merb_usercss/main/index")
    controller.should be_kind_of(MerbUsercss::Main)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/merb_usercss/index.html")
    controller.should be_kind_of(MerbUsercss::Main)
    controller.action_name.should == 'index'
  end
    
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(MerbUsercss::Main, 'index')
    
    url = controller.url(:merb_usercss_default, :controller => 'main', :action => 'show', :format => 'html')
    url.should == "/merb_usercss/main/show.html"
    controller.slice_url(:controller => 'main', :action => 'show', :format => 'html').should == url
    
    url = controller.url(:merb_usercss_index, :format => 'html')
    url.should == "/merb_usercss/index.html"
    controller.slice_url(:index, :format => 'html').should == url
    
    url = controller.url(:merb_usercss_home)
    url.should == "/merb_usercss/"
    controller.slice_url(:home).should == url
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbUsercss::Main, :index)
    controller.public_path_for(:image).should == "/slices/merb_usercss/images"
    controller.public_path_for(:javascript).should == "/slices/merb_usercss/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/merb_usercss/stylesheets"
    
    controller.image_path.should == "/slices/merb_usercss/images"
    controller.javascript_path.should == "/slices/merb_usercss/javascripts"
    controller.stylesheet_path.should == "/slices/merb_usercss/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MerbUsercss::Main._template_root.should == MerbUsercss.dir_for(:view)
    MerbUsercss::Main._template_root.should == MerbUsercss::Application._template_root
  end

end