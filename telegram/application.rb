require_relative 'engine'
require_relative 'screen'

class Application
  def initialize(bot)
    @bot = bot
    @bot.listen do |message|
      case message
      when Telegram::Bot::Types::CallbackQuery
        callback_query_handler(message)
      when Telegram::Bot::Types::Message
        message_handler(message)
      else
        Screen.show_toast(message, @bot, 'Неизвестная команда')
      end
    end
  end

  def callback_query_handler(message)
    if message.data.include?('start_menu')
      start_menu_handler(message)
    elsif message.data.include?('menu_level')
      level_menu_handler(message)
    elsif message.data.include?('game_menu')
      Screen.show_toast(message, @bot, 'game_menu')
    elsif message.data.include?('action')
      action_handler(message)
    end
  end

  def action_handler(message)
    action = Engine.get_action_by_name(message.data)
    if action.nil?
      Screen.show_toast(message, @bot, 'Неизвестное действие')
    else
      Screen.show_toast(message, @bot, 'Запуск действия')
      Engine.run_action(action)
    end
    Screen.show_actions(message, @bot, Engine.actions)
  end

  def start_menu_handler(message)
    case message.data
    when 'start_menu'
      Screen.show_start_menu(message, @bot)
    when 'start_menu_new_game'
      start_new_game(message)
    when 'start_menu_load_game'
      load_game(message)
    when 'start_menu_delete_all_goose'
      delete_all_goose(message)
    else
      Screen.show_toast(message, @bot, 'Неизвестная команда')
    end
  end

  def load_game(message)
    goose = listen_goose_name(message)
    if goose.nil?
      Screen.show_start_menu(message, @bot)
    else
      Screen.show_goose(message, @bot, goose)
      Screen.show_actions(message, @bot, Engine.actions)
    end
  end

  def listen_goose_name(message)
    Screen.show_geese(message.from.id, @bot, Engine.load_geese(message.from.id))
    @bot.listen do |msg|
      case msg
      when Telegram::Bot::Types::CallbackQuery
        goose = Engine.load_goose(msg.from.id, msg.data)
        Screen.show_toast(msg, @bot, 'Гусь не найден :(') if goose.nil?
        return goose
      else
        Screen.show_toast(msg, @bot, 'Неизвестная команда')
      end
    end
  end

  def delete_all_goose(message)
    Engine.delete_all_goose(message.from.id)
    Screen.show_toast(message, @bot, 'Все сохранения удалены')
    Screen.show_start_menu(message, @bot)
  end

  def start_new_game(message)
    name = listen_name(message)
    level = listen_level(message)
    Engine.create_goose(message.from.id, name, level)
    goose = Engine.get_goose(message.from.id)
    Screen.show_goose(message, @bot, goose)
    Screen.show_actions(message, @bot, Engine.actions)
  end

  def listen_level(message)
    Screen.show_menu_level(message, @bot)
    @bot.listen do |msg|
      case msg
      when Telegram::Bot::Types::CallbackQuery
        return level_menu_handler(msg)
      else
        Screen.show_toast(msg, @bot, 'Неизвестная команда')
      end
    end
  end

  def listen_name(message)
    Screen.show_toast(message, @bot, 'Введите имя гуся')
    geese_names = Engine.load_geese_names
    @bot.listen do |msg|
      case msg
      when Telegram::Bot::Types::CallbackQuery
        return msg.text if geese_names.exclude?(msg.text)

        Screen.show_toast(msg, @bot, 'Данное имя уже занято. Придумайте другое')
      else
        Screen.show_toast(msg, @bot, 'Неизвестная команда')
      end
    end
  end

  def level_menu_handler(msg)
    msg.data.remove('menu_level_')
  end

  def message_handler(message)
    case message.text
    when '/start'
      Screen.show_start_menu(message, @bot)
    else
      Screen.show_toast(message, @bot, 'Неизвестная команда')
    end
  end
end
