shared_examples "requires sign in" do
  it "redirects to login path" do
    clear_current_user
    action
    expect(response).to redirect_to login_path
  end
end

shared_examples "requires admin" do
  it "redirects to home path for regular user" do
    session[:user_id] = Fabricate(:user).id
    action
    redirect_to home_path
  end

  it 'sets error flash message' do
    session[:user_id] = Fabricate(:user).id
    action
    expect(flash[:error]).to be_present
  end
end