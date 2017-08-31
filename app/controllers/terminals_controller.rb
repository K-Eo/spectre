class TerminalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_terminal, only: ['show', 'edit', 'update', 'destroy', 'send_token', 'unpair_device']

  def index
    @terminals = Terminal.page(params[:page])
  end

  def new
    @terminal = Terminal.new
  end

  def create
    @terminal = Terminal.new(terminal_params)

    if @terminal.save
      redirect_to terminal_path(@terminal)
    else
      render 'new'
    end
  end

  def show
    if @terminal.paired
      @device = @terminal.device.decorate
    else
      @device_email = DeviceEmail.new
    end
  end

  def edit
  end

  def update
    if @terminal.update(terminal_params)
      flash[:success] = 'Actualizado correctamente.'
      redirect_to terminal_path(@terminal)
    else
      render 'edit'
    end
  end

  def destroy
    @terminal.destroy
    flash[:success] = 'La terminal ha sido eliminada'
    redirect_to terminals_path
  end

  def send_token
    @device_email = DeviceEmail.new(device_email_params)
    @qr_pairing_token = @terminal.pairing_token_png(200)

    if @device_email.valid?
      TerminalMailer.pairing_token(@device_email.email, @terminal).deliver
      flash.now[:success] = "Enviado instrucciones a <strong>#{@device_email.email}</strong>."
    else
      flash.now[:danger] = "No se ha podido enviar el correo. Verifique que sea correcto e intente nuevamente."
    end

    render 'show'
  end

  def unpair_device
    @terminal.unpair_device
    flash[:message] = 'El dispositivo ya no se encuentra asociado a esta terminal.'
    redirect_to terminal_path(@terminal)
  end

  private

    def device_email_params
      params.require(:device_email).permit(:email)
    end

    def terminal_params
      params.require(:terminal).permit(:name)
    end

    def set_terminal
      @terminal = Terminal.find(params[:id]).decorate
    end

end
