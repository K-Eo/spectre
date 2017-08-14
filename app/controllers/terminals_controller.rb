class TerminalsController < ApplicationController
  before_action :set_terminal, only: ['show', 'edit']

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
  end

  def edit
  end

  private

    def terminal_params
      params.require(:terminal).permit(:name)
    end

    def set_terminal
      @terminal = Terminal.find(params[:id])
    end

end
