class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    #@user && @user.authenticate(params[:session][:password])
    if @user &.authenticate(params[:session][:password])
      # forwarding_url = session[:forwarding_url]
      # #session固定攻撃対策
      # reset_session
      # params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)

      # #remember user
      # log_in(@user)
      # redirect_to forwarding_url || @user
      # #flash[:danger] = session[:user_id]

      # #log確認
      # #Rails.logger.info("Session data: #{session.inspect}")
      if @user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        log_in @user
        redirect_to forwarding_url || @user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      #エラー作成
      flash.now[:danger] = "Invalid email/password combination"
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

end
