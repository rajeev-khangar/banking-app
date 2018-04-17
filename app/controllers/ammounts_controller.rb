class AmmountsController < ApplicationController
  before_action :set_user
  

  def index
    @ammounts = @user.ammount
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end
  
end