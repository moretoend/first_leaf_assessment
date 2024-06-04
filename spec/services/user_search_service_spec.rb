require 'rails_helper'

describe UserSearchService do
  let!(:users) { create_list(:user, 10) }

  context 'when a valid User param is sent' do
    it 'filters only by :email' do
      users_to_search = [create(:user, email: "test1@test.com"), create(:user,  email: "test2@test.com")]
      result = subject.call(email: "@test")
      expect(result).to match_array users_to_search.reverse
    end

    it 'filters only by :full_name' do
      users_to_search = [create(:user, full_name: "Some name 1"), create(:user, full_name: "Some name 2")]
      result = subject.call(full_name: "Some na")
      expect(result).to match_array users_to_search.reverse
    end

    it 'filters only by :metadata' do
      users_to_search = [
        create(:user, metadata: "lead product solution architect junior"), create(:user,  metadata: "lead product solution architect senior")
      ]
      result = subject.call(metadata: "product solution architect")
      expect(result).to match_array users_to_search.reverse
    end

    it 'filters by all parameters' do
      users_to_search = [
        create(:user, email: "test1@test.com", full_name: "Some name 1", metadata: "lead product solution architect junior"),
        create(:user, email: "test2@test.com", full_name: "Some name 2", metadata: "lead product solution architect senior")]
      result = subject.call(email: "@test", full_name: "Some", metadata: "product solution architect")
      expect(result).to match_array users_to_search.reverse
    end
  end

  it 'returns all users when no User param is sent' do
    result = subject.call
    expect(result).to match_array users.reverse
  end

  it 'ignores unmapped parameters when sent' do
    result = subject.call({ unmapped: "Some" })
    expect(result).to match_array users.reverse
  end
end
