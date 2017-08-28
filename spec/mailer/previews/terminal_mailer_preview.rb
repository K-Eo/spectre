# Preview all emails at http://localhost:3000/rails/mailers/terminal_mailer
class TerminalMailerPreview < ActionMailer::Preview

  def pairing_token
    terminal = Terminal.new(name: 'foobar')
    terminal.create_pairing_token
    TerminalMailer.pairing_token('foo@bar.com', terminal)
  end

end
