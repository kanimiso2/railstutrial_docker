class LikesController < ApplicationController
    before_action :logged_in_user
    def create
        @micropost = Micropost.find(params[:micropost_id])
        current_user.like(@micropost)
        flash[:success] = "いいねしました！"
        redirect_to root_url
    end
    def destroy
        @micropost = Micropost.find(params[:micropost_id])
        current_user.unlike(@micropost)
        flash[:success] = "いいねを解除しました！"
        redirect_to root_url
      end
end