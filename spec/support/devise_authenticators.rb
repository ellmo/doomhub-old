include Devise::TestHelpers

def sign_in_nobody
  sign_in User.new
end

def sign_in_user
  sign_in FactoryGirl.create(:user)
end

def sign_in_admin
  sign_in FactoryGirl.create(:admin)
end

def sign_in_superadmin
  # @request.env["devise.mapping"] = Devise.mappings[:admin]
  sign_in FactoryGirl.create(:superadmin)
end


