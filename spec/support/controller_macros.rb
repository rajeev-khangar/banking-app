module ControllerMacros
  def login_manager
    @request.env["devise.mapping"] = Devise.mappings[:manager]
    manager = FactoryGirl.create(:manager)
   #user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
    sign_in manager
  end
end