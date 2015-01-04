class Admin::FbApiTokensController < Admin::BaseController
  def index
    @fb_api_token = FbApiToken.new
    @fb_api_tokens = FbApiToken.all
  end

  def show
    @fb_api_token = FbApiToken.find(params[:id])
  end

  def update
    @token = FbApiToken.find(params[:id])
    if params[:fb_api_token].include? :extend
      begin
        o = Koala::Facebook::OAuth.new(params[:fb_api_token][:application_id].to_i, params[:fb_api_token][:application_secret])
        new_token = o.exchange_access_token(@token.token)
        g = Koala::Facebook::API.new(new_token)
        token_info = g.debug_token(new_token)
        @token.update_attributes(
            token: new_token,
            expires: Time.at(token_info['data']['expires_at']).to_datetime,
            application_id: token_info['data']['app_id'].to_i,
            application_name: token_info['data']['application'],
            user_id: token_info['data']['user_id'].to_i,
            purpose: params[:fb_api_token][:purpose]
            )
          redirect_to admin_fb_api_tokens_url notice: 'success!'
      rescue Exception => e
        redirect_to admin_fb_api_tokens_url, notice: e.try(:fb_error_message)
      end
    else
      if @token.update(params[:fb_api_token].permit(:purpose))
        redirect_to admin_fb_api_tokens_url notice: 'success!'
      else
        render 'show'
      end
    end
  end

  def create_using_fb_flow
    fb_application = Admin::FacebookApplication.find(params[:facebook_application_id])
    redirect_to "https://www.facebook.com/dialog/oauth?response_type=token&client_id=#{fb_application.app_id}&redirect_uri=#{admin_facush_callback_url}?application_id=#{params[:facebook_application_id]}"
  end

  def callback_from_facebook
    @application_id = params[:application_id]
  end

  def callback_from_parsed_url_fragment
    # fb_app = Admin::FacebookApplication.find params[:application_id]
    # o = Koala::Facebook::OAuth.new(fb_app.app_id, fb_app.app_secret, "https://www.facebook.com/dialog/oauth?client_id=#{fb_app.app_id}&redirect_uri=#{admin_facush_callback_url}?application_id=#{fb_app.app_id}")
    # o.get_access_token params[:code]
    g = Koala::Facebook::API.new(params[:fragment])
    token_info = g.debug_token(params[:fragment])
    fb_app = Admin::FacebookApplication.find_by_app_id(token_info['data']['app_id'])
    o = Koala::Facebook::OAuth.new(fb_app.app_id, fb_app.app_secret)
    new_token = o.exchange_access_token(params[:fragment])
    new_token_info = g.debug_token(new_token)
    FbApiToken.create(
      token: new_token,
      expires: Time.at(new_token_info['data']['expires_at']).to_datetime,
      application_id: new_token_info['data']['app_id'].to_i,
      application_name: new_token_info['data']['application'],
      user_id: new_token_info['data']['user_id'].to_i
      )
    redirect_to admin_fb_api_tokens_url, flash: {success: t('created')}
  end

  def create
    token = params[:fb_api_token][:token]
    begin
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
        redirect_to admin_fb_api_tokens_url, flash: 'success'
      end
    rescue Exception => e
      redirect_to admin_fb_api_tokens_url, notice: e.try(:fb_error_message)
    end
  end

  def destroy
    FbApiToken.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to admin_fb_api_tokens_url, notice: 'Fb api key was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
