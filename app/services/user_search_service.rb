class UserSearchService
  USER_PARAMS_TO_SEARCH = %i[email full_name metadata].freeze
  private_constant :USER_PARAMS_TO_SEARCH

  def call(search_params = {})
    users = User.order(created_at: :desc)
    USER_PARAMS_TO_SEARCH.each do |param_key|
      param_value = search_params[param_key]
      users.where!(User.arel_table[param_key].matches("%#{param_value}%"))
    end
    users
  end
end
