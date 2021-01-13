class GooseManager
  def delete_all_goose(id)
    user = User.find_by(telegram_id: id)
    user.goose.delete_all
    user.save
  end

  def load_goose(id, name)
    user = User.find_by(telegram_id: id)
    goose = Goose.find_by(name: name)
    return nil if goose.nil?

    user.current_goose_name = name
    user.save
    goose
  end

  def save_goose(id)
    user = User.find_by(telegram_id: id)
    goose = Goose.find_by(name: user.current_goose_name)
    goose.save
    user.save
  end

  def create_goose(id, name, level)
    user = User.find_or_create_by(telegram_id: id)
    create_goose_by_level(user.goose, name, level)
    user.current_goose_name = name
    user.save
  end

  def create_goose_by_level(goose, name, level)
    case level
    when 'easy'
      goose.create(name: name, level: level, alive: true, fun: 100, mana: 0, health: 100, weariness: 0, money: 100)
    when 'middle'
      goose.create(name: name, level: level, alive: true, fun: 50, mana: 0, health: 50, weariness: 0, money: 50)
    when 'hard'
      goose.create(name: name, level: level, alive: true, fun: 10, mana: 0, health: 10, weariness: 0, money: 10)
    end
  end

  def get_goose(id)
    user = User.find_or_create_by(telegram_id: id)
    Goose.find_by(name: user.current_goose_name)
  end

  def load_geese_names
    names = []
    Goose.all.each { |goose| names.push(goose.name) }
    names
  end

  def load_geese(id)
    user = User.find_or_create_by(telegram_id: id)
    user.goose
  end

  # @param [Goose] goose
  def update_alive(goose)
    status_health, message_health = check_health(goose)
    status_mana, message_mana = check_mana(goose)
    status_fun, message_fun = check_fun(goose)
    status_weariness, message_weariness = check_weariness(goose)
    status_money, message_money = check_money(goose)
    message = nil
    [
      message_health,
      message_mana,
      message_fun,
      message_weariness,
      message_money
    ].each do |msg|
      unless msg.nil?
        message = '' if !msg.nil? && message.nil?
        message << "#{msg}\n"
      end
    end
    goose.update(alive: status_health && status_mana && status_fun && status_weariness && status_money)
    message
  end

  def check_health(goose)
    status = goose.health.positive?
    message = nil
    message = "Ваш гусь #{goose.name}, сдох" unless status
    [status, message]
  end

  def check_mana(goose)
    status = goose.mana < 100
    message = nil
    message = "Ваш гусь #{goose.name}, попал в хогвардс" unless status
    [status, message]
  end

  def check_fun(goose)
    status = goose.weariness < 100
    message = nil
    message = "У вашего гуся #{goose.name}, появились суецидальные мысли..." unless status
    [status, message]
  end

  def check_weariness(goose)
    status = goose.weariness < 100
    message = nil
    message = "Ваш гусь #{goose.name}, добегался..." unless status
    [status, message]
  end

  def check_money(goose)
    status = goose.money > -50
    message = nil
    message = "За вашим гусем #{goose.name}, выехали коллекторы..." unless status
    [status, message]
  end

  # min - нельзя меньше чем
  # max - нельзя больше чем
  def param_correct?(goose_param, min, max)
    if min.nil?
      goose_param <= max
    elsif max.nil?
      goose_param >= min
    else
      goose_param <= max && goose_param >= min
    end
  end

  # @param [Goose] goose
  def add_changes(goose, mod)
    fun = goose.fun + mod.fun
    mana = goose.mana + mod.mana
    health = goose.health + mod.health
    weariness = goose.weariness + mod.weariness
    money = goose.money + mod.money
    goose.update(fun: fun, mana: mana, health: health, weariness: weariness, money: money)
  end
end
