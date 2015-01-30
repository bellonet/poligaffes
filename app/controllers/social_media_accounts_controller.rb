class SocialMediaAccountsController < ApplicationController

  def new
    @yair = Yair.new
    @social_media_account = SocialMediaAccount.new
  end

  def search
    @yairs = Yair.where("last_name LIKE ?", "%#{params[:search]}%").paginate(page: params[:page], per_page: 10)
    render :new
  end

  def create
    @yair = Yair.find(params[:yair_id])
    @social_media_account = SocialMediaAccount.new(social_media_account_params)
    @social_media_account.yair = @yair
    if @social_media_account.save
      redirect_to yair_path(@yair)
    else
      render 'yairs/show'
    end
  end

  def edit
    @social_media_account = SocialMediaAccount.find(params[:id])
  end

  def destroy
    @yair = Yair.find(params[:yair_id])
    @social_media_account = SocialMediaAccounts.find(params[:id])
    @social_media_account.destroy
    redirect_to yair_path(@yair)
  end

  private
    def social_media_account_params
      params.require(:social_media_account).permit(:name, :site, :about, :link, :photo)
    end
end
