if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  load_dependency 'merb-slices'
  Merb::Plugins.add_rakefiles "merb_usercss/merbtasks", "merb_usercss/slicetasks", "merb_usercss/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :merb_usercss
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:merb_usercss][:layout] ||= :application
  
  # All Slice code is expected to be namespaced inside a module
  module MerbUsercss
    
    # Slice metadata
    self.description = "MerbUsercss makes it easy to have user-specific CSS"
    self.version = "0.0.1"
    self.author = "Michael D. Ivey"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
      unless Merb.available_mime_types.has_key?(:css)
        Merb.add_mime_type :css, :to_css, %w[text/css], :charset => "utf-8"
      end
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
      Merb::Slices::config[:merb_usercss][:user_block] ||= lambda do |id|
        u = User.get(id)
        u ? u.custom_css : ""
      end
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbUsercss)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :merb_usercss_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      scope.match('/usercss/:id').to(:controller => 'main', :action => 'show', :format => 'css').
        name(:show)
    end

    def self.css_for_user(id)
      Merb::Slices::config[:merb_usercss][:user_block].call(id)
    end

  end
  
  # Setup the slice layout for MerbUsercss
  #
  # Use MerbUsercss.push_path and MerbUsercss.push_app_path
  # to set paths to merb_usercss-level and app-level paths. Example:
  #
  # MerbUsercss.push_path(:application, MerbUsercss.root)
  # MerbUsercss.push_app_path(:application, Merb.root / 'slices' / 'merb_usercss')
  # ...
  #
  # Any component path that hasn't been set will default to MerbUsercss.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbUsercss.setup_default_structure!
  
  # Add dependencies for other MerbUsercss classes below. Example:
  # dependency "merb_usercss/other"

end
