module SessionsHelper
    def log_in(user)
        session[:user_id]= user.id
    end

    #ログイン中のユーザーを返す
    def current_user
        if session[:user_id]
            @current_user ||= User.find_by(id: session[:user_id])
        end
    end
    #current_userメソッド呼び出して確認
    def logged_in?
        !current_user.nil?
    end
    # 現在のユーザーをログアウトする
  def log_out
    reset_session
    @current_user = nil   # 安全のため8.4.3
  end
end
