class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  def new
  end
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      Rails.logger.debug "------------------------------------------------------------------------------------------------Creating reset digest for user: #{@user.name}"
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?                  # （3）への対応
      @user.errors.add(:password, "can't be empty")
      render 'edit', status: :unprocessable_entity
    elsif @user.update(user_params)                     # （4）への対応
      #forgetみたいなやつ？12.18
      reset_session
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity      # （2）への対応
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # 正しいユーザーかどうか確認する
  def valid_user
    unless (@user && @user.activated? &&
            @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end

end
