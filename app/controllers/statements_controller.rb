class StatementsController < ApplicationController
  before_action :authenticate_manager!
  def index
    @user = User.find(params[:user_id])
    @statements = @user.statements
    @q = @statements.ransack(params[:q])
    @statements = @q.result
    respond_to do |format|
      format.html
      format.js
      format.csv { send_data @user.import(@statements), filename: "Statements-#{Date.today}.csv"} 
    end
  end  
end