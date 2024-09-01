# app/controllers/blocks_controller.rb
class BlocksController < ApplicationController
    before_action :logged_in_user
  
    def create
      @user = User.find(params[:blocked_id])
      current_user.block(@user)
      redirect_back(fallback_location: root_url)
    end
  
    def destroy
      @user = User.find(params[:id])
      current_user.unblock(@user)
      redirect_back(fallback_location: root_url)
    end
  end
  