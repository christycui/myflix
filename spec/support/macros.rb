def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(user=nil)
  visit login_path
  fill_in("email_address", with: user.email_address)
  fill_in("password", with: user.password)
  click_button('Sign In')
end

def sign_out
  visit logout_path
end