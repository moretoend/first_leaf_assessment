require 'rails_helper'

describe User do
  subject { build(:user, key: '1234') }

  it { is_expected.to have_secure_password }

  it { is_expected.to have_readonly_attribute(:key) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_most(200) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  
  it { is_expected.to validate_presence_of(:phone_number) }
  it { is_expected.to validate_length_of(:phone_number).is_at_most(20) }
  it { is_expected.to validate_uniqueness_of(:phone_number).case_insensitive }

  it { is_expected.to validate_length_of(:full_name).is_at_most(200) }

  it { is_expected.to validate_length_of(:password).is_at_most(60) }

  it { is_expected.to validate_length_of(:account_key).is_at_most(100).allow_nil }
  it { is_expected.to validate_uniqueness_of(:account_key).allow_nil }

  it { is_expected.to validate_length_of(:metadata).is_at_most(2000) }

  it 'generates a key with 100 characters before validation' do
    subject.validate
    expect(subject.key.size).to eq 100
  end
end
