class CommentsController < ApplicationController

	def create
    @yair = Yair.find(params[:yair_id])
    @comment = @yair.comments.create(comment_params)
    redirect_to yair_path(@yair)
  end
 
  def destroy
    @yair = Yair.find(params[:yair_id])
    @comment = @yair.comments.find(params[:id])
    @comment.destroy
    redirect_to yair_path(@yair)
  end

  private
    def comment_params
      params.require(:comment).permit(:site, :status, :how_long, :body)
    end
end
