class MerbUsercss::Main < MerbUsercss::Application
  provides :css  

  def show
    MerbUsercss.css_for_user(params[:id])
  end
  
end
