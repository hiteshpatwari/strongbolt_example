class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    if current_user.can?(:update, Strongbolt::Role)
      @users = User.all
    else
      @users = [ current_user ]
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)

      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path
  end

  private

  def user_params
    if current_user.can?(:create, User)
      params.require(:user).permit(:email, :password, { category_ids: [] })
    else
      params.require(:user).permit(:email, { category_ids: [] })
    end
  end
end
