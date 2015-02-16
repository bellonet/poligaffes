class HomeController < ApplicationController

  caches_action :index, cache_path: lambda { |e| "home-#{params[:deleted_page]}-#{params[:edited_page]}" }

  before_filter { use_cover_photo 'knesset.jpg' }

  def index
    @deleted_posts = Post.not_empty.deleted.order(created_at: :desc).paginate(page: params[:deleted_page], per_page: 5)
    @edited_posts  = Post.not_empty.edited.last_edit_only.order(created_at: :desc).paginate(page: params[:edited_page], per_page: 5)
    @latest_raw_posts = RawPost.all.order(timestamp: :desc).limit(10)

    @length = 420
  end

  def search
    @yairs = Yair.where("last_name LIKE ?", "%#{params[:search]}%").paginate(page: params[:page], per_page: 20)
    render :index
  end
  
end
