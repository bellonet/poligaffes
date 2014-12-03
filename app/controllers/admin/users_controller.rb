class Admin::UsersController < Admin::BaseController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, :notice => "Signed up!"
    else
      render "new"
    end
  end

  def edit
     @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    session[:user_id] = nil
    @user.destroy

    redirect_to users_path
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
