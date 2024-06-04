require 'rails_helper'

describe UserKeyGenerator do
  it 'generates a random key with 100 characeters' do
    generated_key = described_class.call
    expect(generated_key.length).to eq(100)
  end

  it 'does not return a duplicated key' do
    user = create(:user)
    unused_key = SecureRandom.alphanumeric(100)
    allow(SecureRandom).to receive(:alphanumeric).and_return(user.key, unused_key)
    generated_key = described_class.call
    expect(generated_key).to eq unused_key
  end
end
