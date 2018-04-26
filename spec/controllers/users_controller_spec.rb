require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "POST create" do
    it "should create user" do
      login_manager
      expect(User.count).to eq 0
      post :create, user: FactoryGirl.attributes_for(:user)
      expect(User.count).to eq 1
    end
  end

  describe "GET index" do
    it "assigns @user" do
      login_manager
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe '#edit' do
    it "should render edit page" do
      login_manager
      user = FactoryGirl.create(:user)
      get :edit, id: user.id
      expect(response).to have_http_status(200)
    end
  end

  describe '#withdraw' do
    it "should redirect_to show page" do
      login_manager
      user = FactoryGirl.create(:user)
      get :withdraw, id: user.id, statement: {withdraw: 2000} 
      expect(response).to redirect_to user_path(user)
    end
  end

  describe '#deposit' do
    it "should redirect_to show page" do
      login_manager
      user = FactoryGirl.create(:user)
      get :deposit, id: user.id, statement: {deposit: 2000}
      expect(response).to redirect_to user_path(user)
    end
  end


  describe '#update' do
    it "should update user" do
      login_manager
      user = FactoryGirl.create(:user)

      put :update, id: user.id, user: { email: "example@mail.com"}
      expect(flash[:success]).to eq "Update Successfully."
    end
  end

  describe "DELETE destroy" do
    it "return index " do
      login_manager
      user = FactoryGirl.create(:user)
      expect(User.count).to eq 1
      delete :destroy, id: user.id
      expect(User.count).to eq 0
      expect(response).to redirect_to users_path
    end
  end  
end