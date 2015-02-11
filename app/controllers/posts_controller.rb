class PostsController < ApplicationController
  before_filter { use_cover_photo 'reps.jpg' }

  def show
    @post = Post.find(params[:id])
  end
end
