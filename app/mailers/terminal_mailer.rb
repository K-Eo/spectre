class TerminalMailer < ApplicationMailer
  default from: 'spectre@support.com'

  def pairing_token(email, terminal)
    @email = email
    @qrcode = terminal.pairing_token
    attachments.inline['qrcode.svg'] = terminal.generate_pairing_token_qr
    mail(to: @email, subject: 'Instrucciones para asociar dispositivo')
  end

end
