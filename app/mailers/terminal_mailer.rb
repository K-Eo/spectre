class TerminalMailer < ApplicationMailer
  default from: 'spectre@support.com'

  def pairing_token(email, terminal)
    @email = email
    @qrcode = terminal.pairing_token
    attachments.inline['qrcode.png'] = terminal.qr_pairing_token_png(220).to_s
    mail(to: @email, subject: 'Instrucciones para asociar dispositivo')
  end

end
