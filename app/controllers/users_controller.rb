class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update,:index,:destroy,:following, :followers,:search]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: :destroy 
  before_action :check_blocked_user, only: [:show]
  before_action :check_blocked_user_redirect, only: [:following, :followers]
  
  def index
    @title = "All users"
    @users = User.where(activated: true).where.not(id: blockers_user_ids).paginate(page: params[:page])
  end

  def show 
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new 
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end
  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def search
    @title = "Search users"
    @users = User.where('name LIKE ?', "%#{params[:query]}%")
               .where(activated: true)
               .where.not(id: blockers_user_ids)
               .paginate(page: params[:page])
    render 'index'
  end

  private

    def user_params
      params.require(:user).permit(:name,:email,:password,
      :password_confirmation)
    end

    

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url,status: :see_other) unless current_user.admin?
    end
    # ユーザーがブロックされているかどうかを確認
    def check_blocked_user
      if current_user.blocked_by?(User.find(params[:id]))
        flash.now[:danger] = "You have been blocked by this user."
      end
      # if current_user.nil? 
      #   # 例えば、エラーメッセージを表示する、リダイレクトするなどの処理
      #   redirect_to root_url
      # elsif current_user.blocked_by?(User.find(params[:id]))
      #   redirect_to root_url
      # end
    end
    def check_blocked_user_redirect
      if current_user.blocked_by?(User.find(params[:id]))
        flash.now[:danger] = "You have been blocked by this user."
        @user = User.find(params[:id])
        redirect_to user_path(@user)
      end
    end
end
