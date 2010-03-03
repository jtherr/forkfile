# This controller handles the login/logout function of the site.  
class SessionController < ApplicationController
  ssl_required :login, :create
  ssl_allowed :login_popup


  def new
    redirect_to :action => 'login'
  end
  
  def login
    session[:next_controller] = nil
    session[:next_action] = nil
    
    loginAndContinue()
  end
  
  
  def orderLogin
    session[:next_controller] = "order"
    session[:next_action] = "checkout"
    
    loginAndContinue()
  end
  
  def loginAndContinue
    if current_user != nil
      @user_email = current_user.email
    end
    
    @title = "Login"
    
    render :action => 'login'
  end
  
  
  def login_popup
    session[:next_controller] = nil
    session[:next_action] = nil
    
    @title = "Login"
    
    render :partial => "login_popup"
  end

  def create
    if params['commit'] == "Cancel"
      next_controller = session[:next_controller]
      next_action = session[:next_action]
      next_params = session[:next_params]
 
      session[:next_controller] = nil
      session[:next_action] = nil
      session[:next_params] = nil
 
      if (next_controller != nil && next_action != nil)
        redirect_to url_for(:controller => next_controller, :action => next_action, :overwrite_params => next_params)
      else
        redirect_to :controller => "main", :action => "index"
      end
      
    else
      sessionParams = params[:session]
          
      if sessionParams      
        self.current_user = User.authenticate(sessionParams[:email], sessionParams[:password])
        if logged_in?
          if sessionParams[:remember_me] == "1"
            self.current_user.remember_me
            cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
          end
          
          setCurrentAddressFromCurrentUser()
          
          session[:access_time] = $TIME_ZONE.now
          
          next_controller = session[:next_controller]
          next_action = session[:next_action]
          next_params = session[:next_params]
   
          session[:next_controller] = nil
          session[:next_action] = nil
          session[:next_params] = nil
   
          if (next_controller != nil && next_action != nil)
            redirect_to url_for(:controller => next_controller, :action => next_action, :overwrite_params => next_params)
          else
            redirect_to :controller => "main", :action => "index"
          end
        else          
          @user_email = sessionParams[:email]
          
          @title = "Login"
          @login_error = "Login Failed"
          render :action => "login"
        end
      end
    end
  end

  def logout
    self.current_user.forget_me if logged_in?
    self.current_address = nil
    cookies.delete :auth_token
    reset_session
    session[:search_terms] = {}
    
    redirect_to :controller => 'main', :action => 'index'
  end
end
