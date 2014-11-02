class HomeController < ApplicationController
  def index
  	@posts = Post.all.order timestamp: :desc
  end

  def search
  	@yairs = Yair.where("name LIKE ?", "%#{params[:search]}%")
  	render :index
  end
  
end
