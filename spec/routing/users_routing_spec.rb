require 'rails_helper'

describe 'routes for Users' do
  it 'routes GET /api/users to users#index' do
    expect(get('/api/users')).to route_to("users#index")
  end

  it 'routes POST /api/users to users#create' do
    expect(post('/api/users')).to route_to("users#create")
  end
end
