class ActionManager
  def initialize(goose_manager)
    @goose_manager = goose_manager
  end

  def actions
    Action.all
  end

  def get_action_by_name(name)
    clean_name = name.remove('action_')
    Action.all.select { |action| action.name_action == clean_name }[0]
  end

  # @param [Action] action
  def run_action(id, action)
    user = User.find_by(telegram_id: id)
    goose = Goose.find_by(name: user.current_goose_name)

    success_message = nil
    error_message = nil
    if goose.alive
      error_message = action_conditions_correct?(goose, action.action_conditions)
      return error_message unless error_message.nil?

      @goose_manager.add_changes(goose, action)

      success_message, error_message = add_bonuses(goose, action.bonus_actions)
      return error_message unless error_message.nil?
    end

    error_message = @goose_manager.update_alive(goose)

    if goose.alive
      success_message
    else
      error_message
    end
  end

  # @param [Goose] goose
  def action_conditions_correct?(goose, conditions)
    error_message = nil
    conditions.each do |condition|
      status = condition_correct?(goose, condition)
      return 'ERROR: Неверное условие для действия' if status.nil?

      error_message = '' if !status && error_message.nil?
      error_message << "#{condition.error_message}\n" unless status
    end
    error_message
  end

  # @param [Goose] goose
  def condition_correct?(goose, condition)
    return nil unless states_correct?(condition)
    return nil if condition.min.nil? && condition.max.nil?

    if condition[:fun]
      @goose_manager.param_correct?(goose[:fun], condition[:min], condition[:max])
    elsif condition[:mana]
      @goose_manager.param_correct?(goose[:mana], condition[:min], condition[:max])
    elsif condition[:health]
      @goose_manager.param_correct?(goose[:health], condition[:min], condition[:max])
    elsif condition[:weariness]
      @goose_manager.param_correct?(goose[:weariness], condition[:min], condition[:max])
    elsif condition[:money]
      @goose_manager.param_correct?(goose[:money], condition[:min], condition[:max])
    end
  end

  # @param [ActionCondition] condition
  def states_correct?(condition)
    [
      condition.fun,
      condition.mana,
      condition.health,
      condition.weariness,
      condition.money
    ].select { |state| state == true }.count == 1
  end

  # @param [Goose] goose
  # @param [BonusAction] bonus_action
  def add_bonus(goose, bonus_action)
    error_message = nil
    bonus_action.bonus_conditions.all.each do |bonus_condition|
      status = condition_correct?(goose, bonus_condition)
      return [nil, 'ERROR: Неверное условие для бонуса'] if status.nil?

      unless status
        error_message = '' if error_message.nil?
        error_message << "#{bonus_condition.error_message}\n"
      end
    end

    success_message = nil
    if error_message.nil?
      success_message = "#{bonus_action.success_message}\n"
      @goose_manager.add_changes(goose, bonus_action)
    end
    [success_message, error_message]
  end

  def add_bonuses(goose, bonus_actions)
    success_message = nil
    error_message = nil
    bonus_actions.each do |bonus_action|
      success, error = add_bonus(goose, bonus_action)
      unless success.nil?
        success_message = '' if !success.nil? && success_message.nil?
        success_message << "#{success}\n"
      end
      unless error.nil?
        error_message = '' if !error.nil? && error_message.nil?
        error_message << "#{error}\n"
      end
    end
    [success_message, error_message]
  end
end
