class HomeController < ApplicationController
  def index
  	@posts = Post.all.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
  	@length = 400
  end

  def search
  	@yairs = Yair.where("last_name LIKE ?", "%#{params[:search]}%").paginate(page: params[:page], per_page: 10)
  	render :index
  end
  
end
