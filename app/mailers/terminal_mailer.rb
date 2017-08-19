class TerminalMailer < ApplicationMailer
  default from: 'spectre@support.com'

  def pairing_token(email, terminal)
    @email = email
    @qr_code = terminal.pairing_token
    @qr_image = terminal.pairing_token_png(220)
    mail(to: @email, subject: 'Instrucciones para asociar dispositivo')
  end

end
