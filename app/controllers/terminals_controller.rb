class TerminalsController < ApplicationController
  before_action :set_terminal, only: ['show', 'edit', 'update', 'destroy']

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
    url = "https://spectre.com/#{@terminal.pairing_token}"
    qr_code = RQRCode::QRCode.new(url, size: 4, level: :m)
    @qr_pairing_token = qr_code.as_svg(offset: 0, color: '000', module_size: 6)
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

  private

    def terminal_params
      params.require(:terminal).permit(:name)
    end

    def set_terminal
      @terminal = Terminal.find(params[:id])
    end

end
