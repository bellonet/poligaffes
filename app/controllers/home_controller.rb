class HomeController < ApplicationController

  caches_action :index, cache_path: lambda { |e| "home-#{params[:deleted_page]}-#{params[:edited_page]}" }

  before_filter { use_cover_photo 'knesset.jpg' }

  def index
  	@deleted_posts = Post.all.order(created_at: :desc).where(status: "deleted").paginate(page: params[:deleted_page], per_page: 5)
    @edited_posts = Post.all.order(created_at: :desc).where(status: "edited").paginate(page: params[:edited_page], per_page: 5)
    @latest_raw_posts = RawPost.all.order(created_at: :desc).limit(10)

  	@length = 420
  end

  def search
  	@yairs = Yair.where("last_name LIKE ?", "%#{params[:search]}%").paginate(page: params[:page], per_page: 20)
  	render :index
  end
  
end
