require 'rails_helper'

describe User do
  subject { build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_most(200) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  
  it { is_expected.to validate_presence_of(:phone_number) }
  it { is_expected.to validate_length_of(:phone_number).is_at_most(20) }
  it { is_expected.to validate_uniqueness_of(:phone_number).case_insensitive }

  it { is_expected.to validate_length_of(:full_name).is_at_most(200) }

  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_most(100) }

  it { is_expected.to validate_presence_of(:key) }
  it { is_expected.to validate_length_of(:key).is_at_most(100) }
  it { is_expected.to validate_uniqueness_of(:key) }

  it { is_expected.to validate_length_of(:account_key).is_at_most(100) }
  it { is_expected.to validate_uniqueness_of(:account_key) }

  it { is_expected.to validate_length_of(:metadata).is_at_most(2000) }
end
