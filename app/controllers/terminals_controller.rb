class TerminalsController < ApplicationController

  def index
    @terminals = Terminal.all
  end

  def new
    @terminal = Terminal.new
  end

end
