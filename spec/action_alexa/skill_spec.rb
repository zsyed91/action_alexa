describe ActionAlexa::Skill do
  let(:intent) { double('ActionAlexa::Intent::Base') }
  let(:default_intent) { double('ActionAlexa::Intent::Base') }
  let(:logger) { double('Logger', error: nil) }
  let(:alexa_response) do
    response = ActionAlexa::Response.new
    response.say('Hello World')
  end
  let(:default_alexa_response) do
    response = ActionAlexa::Response.new
    response.say('Default Response')
  end
  let(:alexa_payload) do
    {
      'request' => {
        'type' => 'LaunchIntentRequest'
      }
    }
  end

  before do
    ActionAlexa.configure do |config|
      config.logger = logger
      config.default_intent_response_class = default_intent
    end

    allow(intent).to receive(:new).and_return(intent)
    allow(default_intent).to receive(:new).and_return(default_intent)
  end

  describe '.execute' do
    context 'when intent class exists' do
      before do
        allow(ActionAlexa::Intent::Registry).to(
          receive(:find_intent).and_return(intent)
        )

        allow(intent).to receive(:execute).and_return(alexa_response)
      end

      it 'looks up the intent in the registry' do
        expect(ActionAlexa::Intent::Registry).to(
          receive(:find_intent).with('LaunchIntentRequest').and_return(intent)
        )

        ActionAlexa::Skill.execute(alexa_payload)
      end

      it 'executes the intent' do
        expect(intent).to receive(:new).and_return(intent)

        ActionAlexa::Skill.execute(alexa_payload)
      end

      it 'sends the intent the alexa payload' do
        expect(intent).to(
          receive(:new)
            .with(instance_of(ActionAlexa::AlexaRequest))
            .and_return(intent)
        )

        ActionAlexa::Skill.execute(alexa_payload)
      end

      it 'returns the response from the intent' do
        response = ActionAlexa::Skill.execute(alexa_payload)
        expect(response).to eq(alexa_response)
      end
    end

    context 'when intent class does not exist' do
      before do
        allow(ActionAlexa::Intent::Registry).to(
          receive(:find_intent).and_return(nil)
        )

        allow(default_intent).to(
          receive(:execute).and_return(default_alexa_response)
        )
      end

      it 'invokes the defined default intent' do
        response = ActionAlexa::Skill.execute(alexa_payload)
        expect(response).to eq(default_alexa_response)
      end
    end

    context 'when intent class does not exist and fallback not defined' do
      before do
        ActionAlexa.configure do |config|
          config.default_intent_response_class = nil
        end

        allow(ActionAlexa::Intent::Registry).to(
          receive(:find_intent).and_return(nil)
        )
      end

      it 'returns a default response' do
        fallback_response = ActionAlexa::Response.new.say(
          described_class::MISSING_DEFAULT_INTENT_MESSAGE
        )
        response = ActionAlexa::Skill.execute(alexa_payload)
        expect(response).to eq(fallback_response)
      end
    end
  end
end
