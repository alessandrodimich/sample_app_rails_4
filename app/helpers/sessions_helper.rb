module SessionsHelper

  def sign_in(user,remember_me)
    user.create_remember_token
    if remember_me == "on"
      cookies.permanent[:remember_token] = user.remember_token
    else
      cookies[:remember_token] = user.remember_token
    end

    current_user = user

    if cookies[:star_token]
      user_star_token = User.find_by(star_token: cookies[:star_token])


      if user_star_token
        unless user_star_token == current_user
          cookies.delete(:star_token)
          user.create_star_token
          cookies[:star_token] = user.star_token
        end
      else
        user.create_star_token
        cookies[:star_token] = user.star_token
      end
    else
      user.create_star_token
      cookies[:star_token] = user.star_token
    end
  end



  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by(remember_token: cookies[:remember_token]) if cookies[:remember_token]
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end
