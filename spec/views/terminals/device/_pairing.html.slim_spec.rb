require 'rails_helper'

describe 'terminals/device/_pairing' do
  subject do
    allow(view).to receive(:send_token_terminal_path).and_return('/token')
    terminal = build_stubbed(:terminal, pairing_token: 'foobar')
    assign(:terminal, terminal)
    assign(:device_email, DeviceEmail.new)
    render template: 'terminals/device/_pairing',
           locals: { terminal: terminal.decorate }
           puts rendered
    rendered
  end

  describe 'head' do
    it { is_expected.to have_css('h4.card-title svg.octicon-info') }
    it { is_expected.to have_css('h4.card-title', text: /Asociar dispositivo/) }
  end

  describe 'qr' do
    it { is_expected.to have_css('.h6', text: 'Escanear el código QR') }
    it { is_expected.to have_css('div img[title="QR Image"]') }
  end

  describe 'email' do
    it { is_expected.to have_css('.h6', text: 'Enviar por correo electrónico') }
    it { is_expected.to have_css('form[action="/token"]', id: 'new_device_email') }
    it { is_expected.to have_field('device_email_email') }
    it { is_expected.to have_css('input.btn.btn-primary[type="submit"][value="Enviar"]') }
  end

  describe 'code' do
    it { is_expected.to have_css('.h6', text: 'Ingresar el código manualmente') }
    it { is_expected.to have_css('input[readonly="true"][value="foobar"]') }
  end
end
