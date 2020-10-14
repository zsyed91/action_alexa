describe ActionAlexa::Configuration do
  let(:configuration) { ActionAlexa::Configuration.new }

  describe '#current_user_hook=' do
    it 'takes in a lambda/proc' do
      configuration.current_user_hook = -> { 4 }

      result = configuration.current_user_hook.call
      expect(result).to eq(4)
    end
  end

  describe '#current_user_hook' do
    context 'when used as a setter' do
      it 'requires a block' do
        x = nil
        configuration.current_user_hook { x = 5 }
        expect(configuration.current_user_hook).to be_a(Proc)
      end

      it 'raises an exception if block not set' do
        expect { configuration.current_user_hook }.to(
          raise_error(
            ActionAlexa::MissingConfiguration,
            described_class::MISSING_CURRENT_USER_HOOK_ERROR
          )
        )
      end
    end

    context 'when used as a getter' do
      it 'returns the provided block/proc' do
        result = nil
        configuration.current_user_hook { result = 5 }
        configuration.current_user_hook.call
        expect(result).to eq(5)
      end

      it 'captures any return values from executing the block' do
        configuration.current_user_hook { 15 }
        result = configuration.current_user_hook.call

        expect(result).to eq(15)
      end

      it 'supports blocks with parameters' do
        configuration.current_user_hook(&:even?)
        result = configuration.current_user_hook.call(2)

        expect(result).to be(true)
      end
    end
  end
end
