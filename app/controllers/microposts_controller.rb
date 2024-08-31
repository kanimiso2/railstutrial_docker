class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy,:show]
    before_action :correct_user,   only: :destroy

    def create
        @micropost = current_user.microposts.build(micropost_params)
        @micropost.image.attach(params[:micropost][:image])
        if @micropost.save
            flash[:success] = "Micropost created!"
            if @micropost.parent_post_id
                redirect_to micropost_path(@micropost.parent_post_id)
            else
                redirect_to root_url
            end
        else
            @feed_items = current_user.feed.paginate(page: params[:page])
            render 'static_pages/home', status: :unprocessable_entity
        end
    end

    def destroy
        @micropost.destroy
        flash[:success] = "Micropost deleted"
        if request.referrer.nil?
            redirect_to root_url, status: :see_other
        else
            redirect_to request.referrer, status: :see_other
        end
    end

    def show
        @micropost = Micropost.find_by(id: params[:id])
        if @micropost
            @reply = current_user.microposts.build(parent_post_id: @micropost.id)
            @feed_items = Micropost.where("parent_post_id = ?", @micropost.id).paginate(page: params[:page])
        else
            flash[:danger] = "Micropost not found"
            redirect_to root_url
        end
    end

    def most_liked
        @micropost = Micropost.find_by(id: params[:id]) 
        if @micropost
            @reply = current_user.microposts.build(parent_post_id: @micropost.id)
            @feed_items = Micropost
                .most_liked(@micropost.id)
                .paginate(page: params[:page])
            render "show"
        else
            flash[:danger] = "Micropost not found"
            redirect_to root_url
        end
    end
    
    def newest
        @micropost = Micropost.find_by(id: params[:id])
        if @micropost
            @reply = current_user.microposts.build(parent_post_id: @micropost.id)
            @feed_items = Micropost.where("parent_post_id = ?", @micropost.id).paginate(page: params[:page])
            render "show"
        else
            flash[:danger] = "Micropost not found"
            redirect_to root_url
        end
    end

    private

    def micropost_params
        params.require(:micropost).permit(:content,:image,:parent_post_id)
    end

    def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url, status: :see_other if @micropost.nil?
    end
end
