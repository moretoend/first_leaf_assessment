require 'rails_helper'

describe AccountKeyGeneratorJob do
  let!(:user) { create(:user) }

  before { allow(HTTParty).to receive(:post).and_return(httparty_response) }

  context 'when request to gateway does not work' do
    let!(:httparty_response) { double(code: 422) }

    it 'does not update User account key' do
      described_class.perform_now(user.key)
      user.reload
      expect(user.account_key).to be_nil
    end

    it 'retries to execute the job' do
      expect do
        described_class.perform_now(user.key)
      end.to have_enqueued_job(described_class).with(user.key)
    end
  end

  context 'when request to gateway works' do
    let!(:httparty_response) do
      double(code: 200, parsed_response: { 'email' => user.email, 'account_key' => 'some_account_key'})
    end

    context 'when some error happen with user' do
      it 'does not retry the job' do
        expect do
          described_class.perform_now('some-other-key') rescue ActiveRecord::ActiveRecordError
        end.not_to have_enqueued_job(described_class)
      end
      
      it 'stacks Active Record error' do
        expect do
          described_class.perform_now('some-other-key')
        end.to raise_error(ActiveRecord::ActiveRecordError)
      end

      it 'does not update User account key' do
        described_class.perform_now('some-other-key') rescue ActiveRecord::ActiveRecordError
        user.reload
        expect(user.account_key).to be_nil
      end
    end

    it 'updates User account key when user exists' do
      described_class.perform_now(user.key)
      user.reload
      expect(user.account_key).to eq 'some_account_key'
    end
  end
end
