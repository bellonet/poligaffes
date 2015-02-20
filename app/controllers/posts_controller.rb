class PostsController < ApplicationController
  caches_action :show

  before_filter { use_cover_photo 'post.png' }

  def show
  	@post = Post.find(params[:id])
    @posts = Post.find(params[:id]).raw_post.posts.order(created_at: :desc)
  end
end
