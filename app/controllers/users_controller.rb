class UsersController < ApplicationController

  before_action :find_user, only: [:edit, :update, :show, :change_password, :submit_password]

  # user/sign Up
  def new
    @user = User.new
  end 

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User successfully signed up"
      redirect_to user_path(@user)
    else
      flash[:error] = "User registration failed with errors: #{@user.errors.full_messages.join(", ")}"
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "User successfully Updated"
      redirect_to user_path(@user)
    else
      flash[:error] = "Failed with errors: #{@user.errors.full_messages.join(", ")}"
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def sign_in
    @user = User.where(email: params[:email]).first
    if @user.authenticate(params[:password])
      redirect_to user_path(@user)
    else
      flash[:error] = "User Email/Password not matched"
      render :existing_user
    end
  end

  def existing_user
  end

  def change_password
  end

  def submit_password
    user = @user.authenticate(params[:current_password])
    if user
      user.update_attributes(password: params[:new_password])
      flash[:success] = "Password successfully Updated"
      redirect_to user_path(@user)
    else
      flash[:error] = "Password Update Failed!!/ Check the passwords you entered"
      redirect_to change_password_user_path(@user)
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :dob, :email, :profile_picture, :password)
  end
end
