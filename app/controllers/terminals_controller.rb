class TerminalsController < ApplicationController
  before_action :set_terminal, only: ['show', 'edit', 'update', 'destroy', 'send_token']

  def index
    @terminals = Terminal.page(params[:page])
  end

  def new
    @terminal = Terminal.new
  end

  def create
    @terminal = Terminal.new(terminal_params)

    if @terminal.save
      redirect_to terminals_path
    else
      render 'new'
    end
  end

  def show
    @qr_pairing_token = @terminal.pairing_token_png(200)
    @device_email = DeviceEmail.new
  end

  def edit
  end

  def update
    if @terminal.update(terminal_params)
      redirect_to terminal_path(@terminal)
    else
      render 'edit'
    end
  end

  def destroy
    @terminal.destroy
    redirect_to terminals_path
  end

  def send_token
    @device_email = DeviceEmail.new(device_email_params)
    if @device_email.valid?
      TerminalMailer.pairing_token(@device_email.email, @terminal).deliver_later
      flash[:message] = "Enviado instrucciones a <strong>#{@device_email.email}</strong>."
      redirect_to terminal_path(params[:id])
    else
      @qr_pairing_token = @terminal.pairing_token_png(200)
      flash.now[:type] = "danger"
      flash.now[:message] = "No se ha podido enviar el correo. Verifique que sea correcto e intente nuevamente."
      render 'show'
    end
  end

  private

    def device_email_params
      params.require(:device_email).permit(:email)
    end

    def terminal_params
      params.require(:terminal).permit(:name)
    end

    def set_terminal
      @terminal = Terminal.find(params[:id])
    end

end
