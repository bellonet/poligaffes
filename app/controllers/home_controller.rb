class HomeController < ApplicationController
  def index
  	@posts = Post.all.order(timestamp: :desc).paginate(page: params[:page], per_page: 2)
  end

  def search
  	@yairs = Yair.where("name LIKE ?", "%#{params[:search]}%")
  	render :index
  end
  
end
