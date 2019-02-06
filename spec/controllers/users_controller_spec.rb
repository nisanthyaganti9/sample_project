require "rails_helper"

RSpec.describe UsersController, type: :controller do

  let(:user_params) {
    { 
      user: { 
        first_name: "test",
        last_name: "test",
        dob: Date.today - 25.years,
        email: "t@t.com",
        password: "p",
        profile_picture: fixture_file_upload("#{Rails.root}/spec/test_data/hello.png")
      }
    }
  }

  after :each do
    User.all.delete_all # Do with dbcleaner
  end

  describe "#new" do

    before :each do
      get :new
    end

    it "should be success" do
      expect(response).to have_http_status(:success)
    end

    it "should render new template" do
      expect(response).to render_template("new")
    end

    it "should initialize new user object" do
      expect(assigns(:user).persisted?).to eq false
    end
  end

  describe "#create" do

    context "user created succesfully" do
      before :each do
        allow_any_instance_of(User).to receive(:save).and_return(true)
        allow_any_instance_of(User).to receive(:id).and_return("1")
        post :create, params: user_params
      end

      it "should redirect" do
        expect(response).to have_http_status(:redirect)
      end
    end

    context "user creation failed with invalid params" do
      before :each do
        allow_any_instance_of(User).to receive(:save).and_return(false)
        post :create, params: user_params
      end
      it "should render new template" do
        expect(response).to render_template("new")
      end
    end
  end

  describe "#edit" do
    let(:user) { User.create(user_params[:user]) }

    before :each do
      get :edit, params: {id: user.id}
    end

    it "should be success" do
      expect(response).to have_http_status(:success)
    end

    it "should render edit template" do
      expect(response).to render_template("edit")
    end

    it "should initialize user object" do
      expect(assigns(:user)).to eq user
    end
  end

  describe "#update" do
    let!(:user) { User.create(user_params[:user]) }

    context "user updated succesfully" do
      before :each do
        put :update, params: user_params.merge({:id => user.id})
      end

      it "should redirect" do
        expect(response).to have_http_status(:redirect)
      end
    end

    context "user update failed with invalid params" do
      before :each do
        user_params[:user].merge({
          first_name: nil
        })
        user_params[:user][:first_name] = nil
        put :update, params: user_params.merge({:id => user.id})
      end
      it "should render edit template" do
        expect(response).to render_template("edit")
      end
    end
  end

  describe "#show" do
    let(:user) { User.create(user_params[:user]) }

    before :each do
      get :show, params: {id: user.id}
    end

    it "should be success" do
      expect(response).to have_http_status(:success)
    end

    it "should render show template" do
      expect(response).to render_template("show")
    end

    it "should initialize user object" do
      expect(assigns(:user)).to eq user
    end
  end

  describe "#sign_in" do

    let!(:user) { User.create(user_params[:user]) }

    context "user signed in succesfully" do
      before :each do
        post :sign_in, params: {email: user.email, password: user.password}
      end

      it "should redirect" do
        expect(response).to have_http_status(:redirect)
      end
    end

    context "user signed in failed" do
      before :each do
        post :sign_in, params: {email: user.email, password: "ouieyq"}
      end
      it "should render existing_user template" do
        expect(response).to render_template("existing_user")
      end
    end
  end

  describe "#existing_user" do
    before :each do
      get :existing_user
    end

    it "should be success" do
      expect(response).to have_http_status(:success)
    end

    it "should render existing_user template" do
      expect(response).to render_template("existing_user")
    end
  end

  describe "#change_password" do
    let!(:user) { User.create(user_params[:user]) }
    before :each do
      get :change_password, params: {id: user.id}
    end

    it "should be success" do
      expect(response).to have_http_status(:success)
    end

    it "should render change_password template" do
      expect(response).to render_template("change_password")
    end
  end

  describe "#submit_password" do
    let!(:user) { User.create(user_params[:user]) }

    context "password updated succesfully" do
      before :each do
        post :submit_password, params: {id: user.id, current_password:"p", new_password: "uio"}
      end

      it "should redirect to show page" do
        expect(response).to redirect_to(user_path(user))
      end
    end

    context "password update failed with invalid current password" do
      before :each do
        post :submit_password, params: {id: user.id, current_password:"wer", new_password: "uio"}
      end
      it "should redirect to change password" do
        expect(response).to redirect_to(change_password_user_path(user))
      end
    end
  end
end
