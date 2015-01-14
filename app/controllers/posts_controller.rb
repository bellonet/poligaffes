class PostsController < ApplicationController

  def show
    @post = Post.find(params[:id])
    @length = 9999
  end

  private
    def post_params
      params.require(:post).permit(:status,:duration ,:body, :raw_post)
    end
end
