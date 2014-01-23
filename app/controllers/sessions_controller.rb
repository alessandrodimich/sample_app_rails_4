class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      cookies.permanent[:user_id] = user.id
      flash[:success] = "Logged in!"
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    flash[:info] = 'Logged out!'
    redirect_to root_url
  end

# def user_params
#        params.require(:id)
#     end
end
