require 'rails_helper'

describe AccountKeyGeneratorService do
  subject { described_class.new(account_key_gateway) }

  let(:account_key_gateway) { instance_double('AccountKey', call: 'some_random_account_key') }
  let!(:user) { create(:user) }

  context 'when account key cannot be requested' do
    before { allow(account_key_gateway).to receive(:call).and_raise(RequestError) }

    it 'stacks RequestError' do
      expect { subject.call(user.key) }.to raise_error(RequestError)
    end

    it 'user keep with empty :account_key' do
      subject.call(user.key) rescue RequestError
      user.reload
      expect(user.account_key).to be_nil
    end
  end

  context 'when there is already a user with generated account key' do
    let!(:duplicated_account_key_user) { create(:user, account_key: 'some_random_account_key') }

    it 'stacks ActiveRecord::RecordInvalid' do
      expect { subject.call(user.key) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'user keep with empty :account_key' do
      subject.call(user.key) rescue ActiveRecord::RecordInvalid
      user.reload
      expect(user.account_key).to be_nil
    end
  end

  it 'stacks ActiveRecord::RecordNotFound to be raised when User is not found' do
    expect { subject.call('some_random_key') }.to raise_error(ActiveRecord::RecordNotFound)  
  end
  
  it 'set user account key when user exists and access key is requested' do
    subject.call(user.key)
    user.reload
    expect(user.account_key).to eq('some_random_account_key')
  end
end
