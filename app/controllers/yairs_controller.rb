class YairsController < ApplicationController

  before_filter :authorize, only: [:new, :edit, :destroy]

  def index
    if params[:search]
      @yairs = Yair.where(field: params[:field])
      @yairs = Yair.where('last_name LIKE ?', "%#{params[:search]}%").paginate(page: params[:page], per_page: 10)
    else
      @yairs = Yair.where(field: params[:field])
      @yairs = @yairs.sort_by { |y| y.last_name }.paginate(page: params[:page], per_page: 10)
    end
  end

  def by_letter
    @yairs = Yair.where(field: params[:field]).where('last_name LIKE ?', "#{params[:letter]}%").paginate(page: params[:page], per_page: 10)
    render 'index'
  end

  def new
    @yair = Yair.new
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
    @posts = Yair.find(params[:id]).posts.order(timestamp: :desc).paginate(page: params[:page], per_page: 2)
    @social_media_accounts = Yair.find(params[:id]).social_media_accounts
    @social_media_account = SocialMediaAccount.new
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
