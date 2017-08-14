class TerminalsController < ApplicationController

  def index
    @terminals = Terminal.all
  end

end
