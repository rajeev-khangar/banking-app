class UsersController < ApplicationController
  before_action :authenticate_manager!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  

  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "created successfully."
      redirect_to  users_path
    else
      flash[:alert] = "Please fill required field."
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Update Successfully." 
      redirect_to users_path
    else
      flash[:alert] = @user.errors.full_messages.join(' ,')
      render 'edit'
    end
  end

  def destroy
    flash[:alert] = "Destroy Successfully." if @user.destroy
    redirect_to users_path
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :account_number, :phone_number)
    end
end