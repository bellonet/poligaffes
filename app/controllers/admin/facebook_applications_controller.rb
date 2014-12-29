class Admin::FacebookApplicationsController < Admin::BaseController
  before_action :set_admin_facebook_application, only: [:show, :edit, :update, :destroy]

  # GET /admin/facebook_applications
  # GET /admin/facebook_applications.json
  def index
    @admin_facebook_applications = Admin::FacebookApplication.all
  end

  # GET /admin/facebook_applications/1
  # GET /admin/facebook_applications/1.json
  def show
  end

  # GET /admin/facebook_applications/new
  def new
    @admin_facebook_application = Admin::FacebookApplication.new
  end

  # GET /admin/facebook_applications/1/edit
  def edit
  end

  # POST /admin/facebook_applications
  # POST /admin/facebook_applications.json
  def create

    o = Koala::Facebook::OAuth.new(params[:admin_facebook_application][:app_id], params[:admin_facebook_application][:app_secret])
    g = Koala::Facebook::API.new(o.get_app_access_token)
    app_name = g.debug_token(g.access_token)['data']['application']

    @admin_facebook_application = Admin::FacebookApplication.new(admin_facebook_application_params)
    @admin_facebook_application.name = app_name

    respond_to do |format|
      if @admin_facebook_application.save
        format.html { redirect_to @admin_facebook_application, notice: 'Facebook application was successfully created.' }
        format.json { render :show, status: :created, location: @admin_facebook_application }
      else
        format.html { render :new }
        format.json { render json: @admin_facebook_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/facebook_applications/1
  # PATCH/PUT /admin/facebook_applications/1.json
  def update
    respond_to do |format|
      if @admin_facebook_application.update(admin_facebook_application_params)
        format.html { redirect_to @admin_facebook_application, notice: 'Facebook application was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_facebook_application }
      else
        format.html { render :edit }
        format.json { render json: @admin_facebook_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/facebook_applications/1
  # DELETE /admin/facebook_applications/1.json
  def destroy
    @admin_facebook_application.destroy
    respond_to do |format|
      format.html { redirect_to admin_facebook_applications_url, notice: 'Facebook application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_facebook_application
      @admin_facebook_application = Admin::FacebookApplication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_facebook_application_params
      params.require(:admin_facebook_application).permit(:app_id, :app_secret)
    end
end
