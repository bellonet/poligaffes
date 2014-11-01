class PostsController < ApplicationController

	def create
    @yair = Yair.find(params[:yair_id])
    @post = @yair.posts.create(post_params)
    redirect_to yair_path(@yair)
  end
 
  def destroy
    @yair = Yair.find(params[:yair_id])
    @post = @yair.posts.find(params[:id])
    @post.destroy
    redirect_to yair_path(@yair)
  end

  private
    def post_params
      params.require(:post).permit(:site, :status, :how_long, :body)
    end
end
