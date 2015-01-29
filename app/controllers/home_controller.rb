class HomeController < ApplicationController

  def index
  	@deleted_posts = Post.all.order(created_at: :desc).where(status: "deleted").paginate(page: params[:deleted_page], per_page: 5)
    @edited_posts = Post.all.order(created_at: :desc).where(status: "edited").paginate(page: params[:edited_page], per_page: 5)

  	@length = 420
  end

  def search
  	@yairs = Yair.where("last_name LIKE ?", "%#{params[:search]}%").paginate(page: params[:page], per_page: 10)
  	render :index
  end
  
end
