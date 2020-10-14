describe ActionAlexa::Response do
  let(:response) { described_class.new }

  describe '#say' do
    it 'returns the message for Alexa to say' do
      result = response.say('Hello World')

      expect(result).to eq(
        version: described_class::VERSION,
        sessionAttributes: {},
        response: {
          outputSpeech: {
            type: 'PlainText',
            text: 'Hello World'
          },
          shouldEndSession: true
        }
      )
    end

    context 'given overrides' do
      it 'sets shouldEndSession to true when true' do
        result = response.say('Hello World', should_end_session: true)

        expect(result).to eq(
          version: described_class::VERSION,
          sessionAttributes: {},
          response: {
            outputSpeech: {
              type: 'PlainText',
              text: 'Hello World'
            },
            shouldEndSession: true
          }
        )
      end

      it 'sets shouldEndSession to false when false' do
        result = response.say('Hello World', should_end_session: false)

        expect(result).to eq(
          version: described_class::VERSION,
          sessionAttributes: {},
          response: {
            outputSpeech: {
              type: 'PlainText',
              text: 'Hello World'
            },
            shouldEndSession: false
          }
        )
      end

      it 'adds the account link card when set to true' do
        result = response.say('Hello World', link_account_card: true)

        expect(result).to eq(
          version: described_class::VERSION,
          sessionAttributes: {},
          response: {
            outputSpeech: {
              type: 'PlainText',
              text: 'Hello World'
            },
            card: { type: 'LinkAccount' },
            shouldEndSession: true
          }
        )
      end

      it 'does not add the account link card when set to false' do
        result = response.say('Hello World', link_account_card: false)

        expect(result).to eq(
          version: described_class::VERSION,
          sessionAttributes: {},
          response: {
            outputSpeech: {
              type: 'PlainText',
              text: 'Hello World'
            },
            shouldEndSession: true
          }
        )
      end
    end
  end

  describe '#with_link_account_card' do
    it 'supports chaining' do
      result = response.with_link_account_card.say('Hello World')

      expect(result).to eq(
        version: described_class::VERSION,
        sessionAttributes: {},
        response: {
          outputSpeech: {
            type: 'PlainText',
            text: 'Hello World'
          },
          card: { type: 'LinkAccount' },
          shouldEndSession: true
        }
      )
    end
  end
end
