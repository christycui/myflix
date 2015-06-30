require 'rails_helper'

describe UsersController do
  describe "GET new" do
    it "sets the @user variable" do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  describe "POST create" do
    context "when input is valid" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end
      
      it "create a user" do
        expect(User.count).to eq(1)
      end
      
      it "redirects to login path" do
        expect(response).to redirect_to login_path
      end
    end
    
    context "sending email" do
      
      after { ActionMailer::Base.deliveries.clear }
      
      it 'sends an email to new user when input is valid' do
        post :create, user: Fabricate.attributes_for(:user, email_address: 'example@example.com')
        expect(ActionMailer::Base.deliveries.last.to).to eq(['example@example.com'])
      end
      
      it "sends email containing user's name with valid input" do
        post :create, user: Fabricate.attributes_for(:user, full_name: 'J')
        expect(ActionMailer::Base.deliveries.last.body).to include('J')
      end
      
      it 'does not send out an email with invalid input' do
        post :create, user: Fabricate.attributes_for(:user, email_address: '')
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
    
    context "when input is invalid" do
      before do
        post :create, user: {email_address: "christycui@example.com", full_name: "Christy Cui"}
      end
      
      it "does not create a user when input is invalid" do
        expect(User.count).to eq(0)
      end

      it "renders the new template when input is invalid" do
        expect(response).to render_template :new
      end
      
      it "sets @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
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
end