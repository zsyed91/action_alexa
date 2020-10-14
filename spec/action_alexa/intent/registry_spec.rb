describe ActionAlexa::Intent::Registry do
  let(:registry) { described_class }
  let(:example_intent) { 'ExampleIntent' }
  let(:intent_file) { '/app/intents/example_intent.rb' }
  let(:intent_files) { [intent_file] }
  let(:root) { './' }

  module ExampleIntent; end

  before do
    ActionAlexa.configure do |config|
      config.root = root
    end
    allow(Dir).to receive(:glob).and_return(intent_files)
  end

  describe '.intents' do
    it 'initalizes empty' do
      expect(registry.intents).to be_empty
    end

    it 'returns the list of intents' do
      registry.register_intent(example_intent)

      expect(registry.intents).to(
        eq(example_intent => ExampleIntent)
      )
    end
  end

  describe 'load_registry!' do
    before do
      allow(registry).to receive(:require)
    end

    it 'loads all the intent classes from the intents folder' do
      expect(Dir).to receive(:glob).and_return(intent_files)

      registry.load_registry!

      expect(registry.intents).to(
        eq(example_intent => ExampleIntent)
      )
    end

    it 'searches the intent directory for ruby files' do
      expect(Dir).to(
        receive(:glob)
          .with("#{root}app/intents/*_intent.rb")
          .and_return(intent_files)
      )

      registry.load_registry!
    end
  end

  describe '.find_intent' do
    before do
      allow(Dir).to receive(:glob).and_return(intent_files)
      allow(registry).to receive(:require)

      # Because the registry is a singleton, we are resetting that class
      # variable for testing purposes
      registry.instance_variable_set(:@intents, {})
    end

    it 'loads the registry if empty' do
      expect(registry).to receive(:load_registry!)

      registry.find_intent('Example')
    end

    it 'does not reload the registry' do
      registry.load_registry!
      expect(registry).not_to receive(:load_registry!)

      registry.find_intent('Example')
    end

    it 'finds the intent class for intent name' do
      expect(registry.find_intent('Example')).to eq(ExampleIntent)
    end

    it 'returns nil if no intent found' do
      expect(registry.find_intent('DNE')).to be_nil
    end
  end
end
