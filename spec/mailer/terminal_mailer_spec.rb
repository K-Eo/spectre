require 'rails_helper'

describe TerminalMailer do
  describe '#pairing_token' do
    context 'when user and terminals is valid' do
      let(:terminal) { create(:terminal) }

      it 'sends email' do
        email = TerminalMailer.pairing_token('user@example.com', terminal)
        email.deliver_now

        expect(last_email.from).to eq(['spectre@support.com'])
        expect(last_email.to).to eq(['user@example.com'])
        expect(last_email.subject).to eq('Instrucciones para asociar dispositivo')
      end
    end
  end
end
