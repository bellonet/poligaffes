class PostsController < ApplicationController
  caches_action :show

  before_filter { use_cover_photo 'post.png' }

  def show
    @post = Post.find(params[:id])
  end
end
