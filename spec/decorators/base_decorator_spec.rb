require 'spec_helper'

describe BaseDecorator do
  let(:bd) { BaseDecorator.new('Hello') }

  describe 'methods' do
    describe '#component' do
      it 'returns the component without throwing an error' do
        bd.component
      end
    end

    describe '#helper' do
      it 'returns the helper without throwing an error' do
        bd.helper
      end
    end

    describe '#class' do
      it 'returns the class without throwing an error' do
        expect(bd.class).to eq bd.component.class
      end
    end
  end
end
