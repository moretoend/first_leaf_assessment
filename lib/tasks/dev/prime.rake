namespace :dev do
  desc "Generate rake data for dev environment"
  task prime: :environment do
    return if Rails.env.production?
    FactoryBot.create_list(:user, 50, password: '123456')
  end
end
