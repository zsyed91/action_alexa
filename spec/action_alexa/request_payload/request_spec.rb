describe ActionAlexa::RequestPayload::Request do
  let(:request) { ActionAlexa::AlexaRequest.new(alexa_payload) }

  let(:alexa_payload) do
    {
      'request' => {
        'type' => 'IntentRequest',
        'requestId' => 'amzn1.echo-api.request.requestId',
        'locale' => 'en-US',
        'timestamp' => '2020-08-26T22:51:39Z',
        'intent' => {
          'name' => 'AMAZON.PauseIntent',
          'confirmationStatus' => 'NONE'
        },
        'dialogState' => 'STARTED'
      }
    }
  end

  describe '#type' do
    it 'returns the type' do
      expect(request.type).to eq('IntentRequest')
    end
  end

  describe '#intent_name' do
    it 'returns the type for non-IntentRequest types' do
      alexa_payload['request']['type'] = 'AuthenticationRequest'
      expect(request.intent_name).to eq('AuthenticationRequest')
    end

    it 'returns the intent name for IntentRequest types' do
      expect(request.intent_name).to eq('Pause')
    end
  end

  describe '#request_id' do
    it 'returns the request id' do
      expect(request.request_id).to eq('amzn1.echo-api.request.requestId')
    end
  end

  describe '#timestamp' do
    it 'returns the timestamp' do
      expect(request.timestamp).to eq('2020-08-26T22:51:39Z')
    end
  end

  describe '#locale' do
    it 'returns the locale' do
      expect(request.locale).to eq('en-US')
    end
  end

  describe '#link_result_should_be_returned?' do
    it 'returns false if key is missing' do
      expect(request.link_result_should_be_returned?).to be(false)
    end

    it 'returns false if set to false' do
      alexa_payload['request']['shouldLinkResultBeReturned'] = false
      expect(request.link_result_should_be_returned?).to be(false)
    end

    it 'returns true if set to true' do
      alexa_payload['request']['shouldLinkResultBeReturned'] = true
      expect(request.link_result_should_be_returned?).to be(true)
    end
  end

  describe '#slot' do
    it 'returns nil for missing slot' do
      expect(request.slot('slot')).to be_nil
    end

    it 'returns the slot when it exists' do
      alexa_payload['request']['intent']['slots'] = { 'slot' => 1 }
      expect(request.slot('slot')).to eq(1)
    end
  end

  describe '#slots' do
    it 'returns nil if slots not provided' do
      expect(request.slots).to be_nil
    end

    it 'returns list of slots' do
      alexa_payload['request']['intent']['slots'] = { 'slot' => 1 }
      expect(request.slots).to eq('slot' => 1)
    end
  end

  describe '#slots?' do
    it 'returns false if slots is missing' do
      expect(request.slots?).to be(false)
    end

    it 'returns true if slots are provided' do
      alexa_payload['request']['intent']['slots'] = { 'slot' => 1 }
      expect(request.slots?).to be(true)
    end
  end

  describe '#slot?' do
    it 'it returns true for slots that exist' do
      alexa_payload['request']['intent']['slots'] = { 'slot' => 1 }
      expect(request.slot?('slot')).to be(true)
    end

    it 'return false for empty slots' do
      expect(request.slot?('slot')).to be(false)
    end

    it 'returns false for non-existant slots' do
      alexa_payload['request']['intent']['slots'] = { 'slot' => 1 }
      expect(request.slot?('slot123')).to be(false)
    end
  end
end
