class TerminalMailer < ApplicationMailer
  default from: 'spectre@support.com'

  def pairing_token(email, qrcode)
    @email = email
    @qrcode = qrcode
    mail(to: @email, subject: 'Instrucciones para asociar dispositivo')
  end

end
