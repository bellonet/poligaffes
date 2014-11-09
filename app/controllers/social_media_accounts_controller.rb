class SocialMediaAccountsController < ApplicationController
	def index
    @social_media_accounts = SocialMediaAccount.all
  end

	def create
    @yair = Yair.find(params[:yair_id])
    @social_media_account = @yair.social_media_accounts.create(social_media_account_params)
    redirect_to yair_path(@yair)
  end

  def destroy
    @yair = Yair.find(params[:yair_id])
    @social_media_account = SocialMediaAccounts.find(params[:id])
    @social_media_account.destroy
    redirect_to yair_path(@yair)
  end

  private
    def social_media_account_params
      params.require(:social_media_account).permit(:site, :link, :photo)
    end
end
