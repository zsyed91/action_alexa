describe ActionAlexa::Intent::Base do
  let(:intent) { described_class.new(alexa_payload) }
  let(:alexa_payload) do
    ActionAlexa::AlexaRequest.new(
      'session' => {
        'user' => {
          'accessToken' => 'token',
          'userId' => 'userId'
        }
      }
    )
  end
  let(:http) { double('Net::HTTP') }
  let(:response) do
    double('Net::HTTP::Response', body: response_body.to_json)
  end
  let(:response_body) { { 'user_id' => 'user_id' } }

  before do
    allow(Net::HTTP).to receive(:new).and_return(http)
    allow(http).to receive(:request).and_return(response)
    allow(http).to receive(:use_ssl=)
    allow(http).to receive(:verify_mode=)

    ActionAlexa.configure do |config|
      config.current_user_hook { 'application_user' }
    end
  end

  describe '#execute' do
    it 'asserts implementation exception' do
      base = described_class.new(alexa_payload)

      expect { base.execute }.to(
        raise_error('Implement this method in your intent subclass')
      )
    end
  end

  describe '#current_user' do
    it 'fetches the application user' do
      expect(intent.current_user).to eq('application_user')
    end

    it 'calls the Amazon api with SSL' do
      expect(http).to receive(:use_ssl=).with(true)

      intent.current_user
    end

    it 'calls the Amazon api with verify mode' do
      expect(http).to receive(:verify_mode=).with(OpenSSL::SSL::VERIFY_PEER)

      intent.current_user
    end

    it 'raises an error when the custom user hook is not set' do
      ActionAlexa.configure do |config|
        config.current_user_hook = nil
      end

      expect { intent.current_user }.to(
        raise_error(ActionAlexa::MissingConfiguration)
      )
    end
  end
end
