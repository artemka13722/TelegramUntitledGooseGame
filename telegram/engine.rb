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
    Action.all.select { |action| action.name_action == clean_name }
  end

  def self.run_action(action); end
end
