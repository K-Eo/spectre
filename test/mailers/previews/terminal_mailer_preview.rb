# Preview all emails at http://localhost:3000/rails/mailers/terminal_mailer
class TerminalMailerPreview < ActionMailer::Preview

  def pairing_token
    terminal = Terminal.first
    TerminalMailer.pairing_token('foo@bar.com', terminal)
  end

end
