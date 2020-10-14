describe ActionAlexa::RequestPayload::Session do
  let(:request) { ActionAlexa::AlexaRequest.new(alexa_payload) }
  let(:alexa_payload) do
    {
      'session' => {
        'new' => true,
        'sessionId' => 'amzn1.echo-api.session.sessionId',
        'application' => {
          'applicationId' => 'amzn1.ask.skill.applicationId'
        },
        'user' => {
          'userId' => 'amzn1.ask.account.123',
          'accessToken' => 'Tlza|67'
        }
      }
    }
  end

  describe '#new?' do
    it 'returns true when the new key is set to true' do
      expect(request.new?).to be(true)
    end

    it 'returns false when the new key is not present' do
      alexa_payload['session'].delete('new')
      expect(request.new?).to be(false)
    end

    it 'returns false when the new key is set to false' do
      alexa_payload['session']['new'] = false
      expect(request.new?).to be(false)
    end
  end

  describe '#session_id' do
    it 'returns the session id' do
      expect(request.session_id).to eq('amzn1.echo-api.session.sessionId')
    end
  end

  describe '#application_id' do
    it 'returns the application id' do
      expect(request.application_id).to eq('amzn1.ask.skill.applicationId')
    end
  end

  describe '#user_id' do
    it 'returns the user id' do
      expect(request.user_id).to eq('amzn1.ask.account.123')
    end
  end

  describe '#user_access_token_present?' do
    it 'returns true when access token is present' do
      expect(request.user_access_token_present?).to be(true)
    end

    it 'returns false when access token is not present' do
      alexa_payload['session']['user'].delete('accessToken')
      expect(request.user_access_token_present?).to be(false)
    end
  end

  describe '#access_token' do
    it 'returns the access token' do
      expect(request.access_token).to eq('Tlza|67')
    end
  end
end
