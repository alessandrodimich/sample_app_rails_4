class SessionsController < ApplicationController

  def new
  end

  def create
<<<<<<< HEAD
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
=======
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
>>>>>>> parent of 2ba2a17... Revert e89b86d..b031a90
      sign_in user
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out(current_user)
    redirect_to root_url
  end
end