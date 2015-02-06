class Admin::SocialMediaAccountsController < Admin::BaseController
  def new
    @yair = Yair.new
    @social_media_account = SocialMediaAccount.new
  end

  def create
    #if..
      #@yair = Yair.find(params[:yair_id])
    #else
    if @yair.save
      redirect_to @yair
    else
      render 'new'
    end
    #end
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
end