require 'rails_helper'

describe UsersController do
  describe "GET new" do
    it "sets the @user variable" do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end

    context "when a token is present" do
      it "sets @user's email as invitation recipient's email" do
        invitation = Fabricate(:invitation)
        get :new, token: invitation.token
        expect(assigns(:user).email_address).to eq(invitation.email)
      end

      it "sets @invitation variable" do
        invitation = Fabricate(:invitation)
        get :new, token: invitation.token
        expect(assigns(:invitation)).to eq(invitation)
      end

      it "redirects to invlid token page if token is expired" do
        get :new, token: nil
        expect(response).to redirect_to invalid_token_path
      end
    end
  end
  describe "POST create" do
    context "successful user signup" do
      it "redirects to login path" do
        result = double('signup_result', successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to login_path
      end
    end
    
    context "signup failure" do
      before do
        result = double('signup_result', successful?: false, error_message: 'error_message')
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end
      
      it "sets @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "renders new template" do
        expect(response).to render_template 'new'
      end

      it "sets the flash error" do
        expect(flash[:error]).to eq('error_message')
      end
    end
  end
  
  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 1 }
    end
    
    it "sets @user variable" do
      set_current_user
      user = Fabricate(:user)
      get :show, id: user
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'PATCH update' do

    it 'updates @user variable' do
      user = Fabricate(:user)
      patch :update, id: user, user: {password: 'new_pw'}
      expect(user.reload.authenticate('new_pw')).to equal(user)
    end

    it 'redirects to user page' do
      set_current_user
      user = Fabricate(:user)
      patch :update, id: user, user: {password: 'new_pw'}
      expect(response).to redirect_to login_path
    end
  end
end