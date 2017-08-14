class TerminalsController < ApplicationController

  def index
    @terminals = Terminal.all
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

  private

    def terminal_params
      params.require(:terminal).permit(:name)
    end

end
