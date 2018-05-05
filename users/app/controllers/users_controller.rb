class UsersController < ApplicationController
  include Petra::Rails::Controller
  use_petra_transaction with_session_key: 'petra_transaction_id', except: %i[reset commit]

  #----------------------------------------------------------------
  #                            CRUD
  #----------------------------------------------------------------

  def index
    @users = User.all.petra
  end

  def new
    @user = User.new
  end

  def create
    @user = User.petra.create(create_update_params)
    redirect_to users_path
  end

  def edit
    @user = User.petra.find(params[:id])
    render :new
  end

  def update
    @user = User.petra.find(params[:id])
    @user.update_attributes(create_update_params)
    redirect_to users_path
  end

  def destroy
    @user = User.petra.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  #----------------------------------------------------------------
  #                      Transaction Handling
  #----------------------------------------------------------------

  def commit
    petra_transaction do
      Petra.commit!
    end
    redirect_to users_path
  end

  def reset
    petra_transaction do
      raise Petra::Reset
    end
    redirect_to users_path
  end

  private

  def create_update_params
    params.require(:user).permit(:first_name, :last_name, :role)
  end
end
