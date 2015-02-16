class PostsController < ApplicationController
  caches_action :show

  before_filter { use_cover_photo 'post.jpg' }

  def show
    @post = Post.find(params[:id])
  end
end
