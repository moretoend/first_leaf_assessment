class UsersController < ApplicationController
  def index
    search_service = UserSearchService.new
    @users = search_service.call(search_params)
  end

  private

  def search_params
    params.delete(:user)
    params.permit(:email, :full_name, :metadata)
  end
end
