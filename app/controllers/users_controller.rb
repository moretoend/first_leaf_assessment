class UsersController < ApplicationController
  def index
    search_service = UserSearchService.new
    @users = search_service.call(search_params)
  end

  def create
    @user = User.create!(user_params)
    render @user, status: :created
  rescue ActiveRecord::RecordInvalid => e
    @errors = e.record.errors.full_messages
    render 'shared/error', status: :unprocessable_entity
  end

  private

  def search_params
    params.delete(:user)
    params.permit(:email, :full_name, :metadata)
  end

  def user_params
    params.delete(:user)
    params.permit(:email, :phone_number, :full_name, :password, :metadata)
  end
end
