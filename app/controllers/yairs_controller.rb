class YairsController < ApplicationController
  caches_action :show

  before_filter :authorize, only: [:new, :edit, :destroy]
  before_filter { use_cover_photo 'reps.jpg' }

  def index
      @yair = Yair.where(field: params[:field])
      @yair = @yair.sort_by { |y| y.last_name }.paginate(page: params[:page], per_page: 20)

      if params[:field] == "figures"
        use_cover_photo 'figures.jpg' 
      end
  end

  def by_letter
    @yair = Yair.where(field: params[:field]).where('last_name LIKE ?', "#{params[:letter]}%").paginate(page: params[:page], per_page: 10)
    render 'index'
  end

  def show
    @yair = Yair.find(params[:id])
    @social_media_accounts = Yair.find(params[:id]).social_media_accounts
    @length = 420

    @deleted_posts = @yair.posts.not_empty.deleted.order(created_at: :desc).paginate(page: params[:deleted_page], per_page: 5)
    @edited_posts  = @yair.posts.not_empty.edited.last_edit_only.order(created_at: :desc).paginate(page: params[:edited_page], per_page: 5)

    @latest_raw_posts = RawPost.all.order(created_at: :desc).limit(5)

  end

  private
    def yair_params
      params.require(:yair).permit(:first_name, :last_name, :party, :field)
    end
end
