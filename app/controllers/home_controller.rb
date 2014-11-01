class HomeController < ApplicationController
  def index
  end

  def search
  	@yairs = Yair.where("name LIKE ?", "%#{params[:search]}%")
  	render :index
  end
  
end
