class Engine
  def self.delete_all_goose(id)
    user = User.find_by(telegram_id: id)
    user.goose.delete_all
    user.save
  end

  def self.load_goose(id, name)
    user = User.find_by(telegram_id: id)
    goose = Goose.find_by(name: name)
    return nil if goose.nil?

    user.current_goose_name = name
    user.save
    goose
  end

  def self.save_goose(id)
    user = User.find_by(telegram_id: id)
    goose = Goose.find_by(name: user.current_goose_name)
    goose.save
    user.save
  end

  def self.create_goose(id, name, level)
    user = User.find_or_create_by(telegram_id: id)
    create_goose_by_level(user.goose, name, level)
    user.current_goose_name = name
    user.save
  end

  def self.create_goose_by_level(goose, name, level)
    case level
    when 'easy'
      goose.create(name: name, level: level, alive: true, fun: 100, mana: 0, health: 100, weariness: 0, money: 100)
    when 'middle'
      goose.create(name: name, level: level, alive: true, fun: 50, mana: 0, health: 50, weariness: 0, money: 50)
    when 'hard'
      goose.create(name: name, level: level, alive: true, fun: 10, mana: 0, health: 10, weariness: 0, money: 10)
    end
  end

  def self.get_goose(id)
    user = User.find_or_create_by(telegram_id: id)
    Goose.find_by(name: user.current_goose_name)
  end

  def self.load_geese_names
    names = []
    Goose.all.each { |goose| names.push(goose.name) }
    names
  end

  def self.load_geese(id)
    user = User.find_by(telegram_id: id)
    user.goose
  end

  def self.actions
    Action.all
  end

  def self.get_action_by_name(name)
    clean_name = name.remove('action_')
    Action.all.select { |action| action.name_action == clean_name }[0]
  end

  # @param [Action] action
  def self.run_action(id, action)
    user = User.find_by(telegram_id: id)
    goose = Goose.find_by(name: user.current_goose_name)

    error_message = action_conditions_correct?(goose, action.action_conditions)
    return error_message unless error_message.nil?

    launch_mod(goose, action)

    success_message, error_message = add_bonuses(goose, action.bonus_actions)
    return error_message unless error_message.nil?

    success_message
  end

  # @param [Goose] goose
  def self.action_conditions_correct?(goose, conditions)
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
  def self.condition_correct?(goose, condition)
    return nil unless states_correct?(condition)
    return nil if condition.min.nil? && condition.max.nil?

    if condition[:fun]
      goose_param_correct?(goose[:fun], condition[:min], condition[:max])
    elsif condition[:mana]
      goose_param_correct?(goose[:mana], condition[:min], condition[:max])
    elsif condition[:health]
      goose_param_correct?(goose[:health], condition[:min], condition[:max])
    elsif condition[:weariness]
      goose_param_correct?(goose[:weariness], condition[:min], condition[:max])
    elsif condition[:money]
      goose_param_correct?(goose[:money], condition[:min], condition[:max])
    end
  end

  # min - нельзя меньше чем
  # max - нельзя больше чем
  def self.goose_param_correct?(goose_param, min, max)
    if min.nil?
      goose_param <= max
    elsif max.nil?
      goose_param >= min
    else
      goose_param <= max && goose_param >= min
    end
  end

  # @param [ActionCondition] condition
  def self.states_correct?(condition)
    [
      condition.fun,
      condition.mana,
      condition.health,
      condition.weariness,
      condition.money
    ].select { |state| state == true }.count == 1
  end

  # @param [Goose] goose
  def self.launch_mod(goose, mod)
    fun = goose.fun + mod.fun
    mana = goose.mana + mod.mana
    health = goose.health + mod.health
    weariness = goose.weariness + mod.weariness
    money = goose.money + mod.money
    goose.update(fun: fun, mana: mana, health: health, weariness: weariness, money: money)
  end

  # @param [Goose] goose
  # @param [BonusAction] bonus_action
  def self.add_bonus(goose, bonus_action)
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
      launch_mod(goose, bonus_action)
    end
    [success_message, error_message]
  end

  def self.add_bonuses(goose, bonus_actions)
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
