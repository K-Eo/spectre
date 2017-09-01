require 'rails_helper'

describe ApplicationDecorator do
  describe '#handle_present' do
    before do
      @decorator = ApplicationDecorator.new(Class.new)
    end

    context 'when value is nil' do
      it 'raises exception' do
        expect { @decorator.handle_present(nil) }.to raise_exception('Value must exists')
      end
    end

    context 'when value is set' do
      context 'and when block is set' do
        it 'returns yield block' do
          expect(@decorator.handle_present('foo') { 'bar' }).to eq('bar')
        end
      end

      context 'and when block is not set' do
        it 'returns value' do
          expect(@decorator.handle_present('foo')).to eq('foo')
        end
      end
    end

    context 'when value is not set' do
      context 'and when fallback is not set' do
        it 'returns default fallback' do
          expect(@decorator.handle_present('')).to eq('no given')
        end
      end

      context 'and when fallback is set' do
        it 'returns given fallback' do
          expect(@decorator.handle_present('', 'foobar')).to eq('foobar')
        end
      end
    end
  end
end
