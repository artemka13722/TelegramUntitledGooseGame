class Engine
  attr_reader :goose_manager, :action_manager

  def initialize
    @goose_manager = GooseManager.new
    @action_manager = ActionManager.new(@goose_manager)
  end
end
