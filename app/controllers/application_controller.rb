class ApplicationController < ActionController::Base
    include SessionsHelper

    private
    def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = "Please log in."
          redirect_to login_url, status: :see_other
        end
    end
    # 現在のユーザーがブロックしているユーザーのIDを取得
    def blockers_user_ids
        current_user.blockers.pluck(:id)
    end

end
