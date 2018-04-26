class UsersController < ApplicationController
  before_action :authenticate_manager!
  before_action :set_user, only: [:show, :edit, :update, :destroy, :withdraw, :deposit]
  

  def index
    @users = User.all
    @q = @users.ransack(params[:q])
    @users = @q.result
    respond_to do |format|
      format.html
      format.js
      format.csv { send_data User.import(User.all), filename: "Statements-#{Date.today}.csv"} 
    end  
  end
  
  def new
    @user = User.new
    @user.addresses.new
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
    @statement = Statement.new
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

  def withdraw
    if params[:statement][:withdraw].present?
      if @user.withdraw(params[:statement][:withdraw].to_f)
        flash[:success] = "your have successfully withdraw #{params[:statement][:withdraw].to_f}"
      else
        flash[:error] = @user.errors.full_messages.join(' ,')
      end
    else
      flash[:alert] = "Please enter amount"
    end
    redirect_to user_path(@user)
  end

  def deposit
    if params[:statement][:deposit].present? 
      if @user.deposit(params[:statement][:deposit].to_f)
        flash[:success] = "You have successfully deposit #{params[:statement][:deposit].to_f}"
      else
        flash[:error] = @user.errors.full_messages.join(' ,')
      end
    else
      flash[:alert] = "Please enter amount"
    end
    redirect_to user_path(@user)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:first_name, :middle_name, :last_name, :email, :account_number, :phone_number, :aadhaar_number, :pancard_number,  addresses_attributes: [:id, :address_type, :line1_address, :line2_address, :landmark, :district, :city, :state, :country, :pincode])
    end
end