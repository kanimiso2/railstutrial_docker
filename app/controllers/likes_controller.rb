class LikesController < ApplicationController
    before_action :logged_in_user
    def create
        @micropost = Micropost.find(params[:micropost_id])
        current_user.like(@micropost)
        flash[:success] = "いいねしました！"
        if request.referrer.nil?
            redirect_to root_url
        else
            redirect_to request.referrer
        end
        #redirect_back(fallback_location: root_url)
        #redirect_to root_url
    end
    def destroy
        @micropost = Micropost.find(params[:micropost_id])
        current_user.unlike(@micropost)
        flash[:success] = "いいねを解除しました！"
        if request.referrer.nil?
            redirect_to root_url, status: :see_other
        else
            redirect_to request.referrer, status: :see_other
        end
        #redirect_back(fallback_location: root_url)
        #redirect_to root_url
    end
end