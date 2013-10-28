include Devise::TestHelpers

def sign_in_nobody
  @request.env["devise.mapping"] = Devise.mappings[:user]
  sign_in User.new
end

def sign_in_user
  @request.env["devise.mapping"] = Devise.mappings[:user]
  sign_in FactoryGirl.create(:user)
end

def sign_in_admin
  @request.env["devise.mapping"] = Devise.mappings[:user]
  sign_in FactoryGirl.create(:admin)
end

def sign_in_superadmin
  @request.env["devise.mapping"] = Devise.mappings[:user]
  sign_in FactoryGirl.create(:superadmin)
end


