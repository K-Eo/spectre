require 'rails_helper'

describe ApplicationHelper do
  describe '#flash_message' do
    context 'when has one' do
      it 'returns wrapper' do
        allow(helper).to receive(:flash).and_return({ notice: 'foobar' })
        expected = %{class="flash-message alert alert-success alert-dismissable fade show my-0"}
        expect(helper.flash_message).to match(expected)
      end

      it 'includes flash content' do
        allow(helper).to receive(:flash).and_return({ notice: 'foobar' })
        expect(helper.flash_message).to match(%{foobar})
      end

      it 'includes alert type' do
        allow(helper).to receive(:flash).and_return({ foobar: 'foobar' })
        expect(helper.flash_message).to match(%{alert-foobar})
      end
    end

    context 'when flash is empty' do
      it 'returns empty string' do
        expect(helper.flash_message).to eq('')
      end
    end

    context 'when has two or more' do
      it 'returns stacked alerts' do
        allow(helper).to receive(:flash).and_return({ notice: 'foobar', danger: 'foobaz' })
        content = helper.flash_message
        expect(content).to match(%{alert-success})
        expect(content).to match(%{foobar})
        expect(content).to match(%{alert-danger})
        expect(content).to match(%{foobaz})
      end
    end

    context 'when col is specified' do
      it 'returns alert with col wrapper' do
        allow(helper).to receive(:flash).and_return({ notice: 'foobar' })
        expect(helper.flash_message('col-10')).to match(%{class="col-10"})
      end
    end

    context 'when type is alert' do
      it 'returns alert-danger' do
        allow(helper).to receive(:flash).and_return({ alert: 'foobaz' })
        expect(helper.flash_message).to match(%{alert-danger})
      end
    end

    context 'when type is notice' do
      it 'returns alert-success' do
        allow(helper).to receive(:flash).and_return({ notice: 'foobaz' })
        expect(helper.flash_message).to match(%{alert-success})
      end
    end

    context 'when type is any other' do
      it 'returs given type' do
        allow(helper).to receive(:flash).and_return({ foo: 'bar' })
        expect(helper.flash_message).to match(%{alert-foo})
      end
    end
  end
end
