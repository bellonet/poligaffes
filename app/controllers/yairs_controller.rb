class YairsController < ApplicationController

  before_filter :authorize, only: [:new, :edit, :destroy]
  before_filter { use_cover_photo 'reps.png' }

  def index
      @yair = Yair.where(field: params[:field])
      @yair = @yair.sort_by { |y| y.last_name }.paginate(page: params[:page], per_page: 20)

      if params[:field] == "figures"
        use_cover_photo 'figures.png' 
      end
  end

  def by_letter
    @yair = Yair.where(field: params[:field]).where('last_name LIKE ?', "#{params[:letter]}%").paginate(page: params[:page], per_page: 10)
    render 'index'
  end

  def edit
    @yair = Yair.find(params[:id])
  end

  def update
    @yair = Yair.find(params[:id])
 
    if @yair.update(yair_params)
      redirect_to @yair
    else
      render 'edit'
    end
  end

  def create
    @yair = Yair.new(yair_params)
    if @yair.save
      redirect_to @yair
    else
      render 'new'
    end
  end

  def show
    @yair = Yair.find(params[:id])
    @social_media_accounts = Yair.find(params[:id]).social_media_accounts
    @length = 420

    @latest_raw_posts = RawPost.all.order(created_at: :desc).limit(5)

  end

  def destroy
    @yair = Yair.find(params[:id])
    @yair.destroy
 
    redirect_to yairs_path
  end

  private
    def yair_params
      params.require(:yair).permit(:first_name, :last_name, :party, :field)
    end
end
