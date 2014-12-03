class Admin::FbApiTokensController < Admin::BaseController
  def index
    @fb_api_token = FbApiToken.new
    @fb_api_tokens = FbApiToken.all
  end

  def show
  end

  def create
    token = params[:fb_api_token][:token]
    g = Koala::Facebook::API.new(token)
    token_info = g.debug_token(token)
    if token_info['data']['is_valid']
      FbApiToken.create(
        token: token,
        expires: Time.at(token_info['data']['expires_at']).to_datetime,
        application_id: token_info['data']['app_id'].to_i,
        application_name: token_info['data']['application'],
        user_id: token_info['data']['user_id'].to_i
        )
      redirect_to :index, flash: 'success'
    end
    redirect_to :index
  end

  def destroy
    FbApiToken.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to admin_fb_api_tokens_url, notice: 'Fb api key was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
