require File.expand_path('../config/environment', __dir__)
require 'telegram/bot'
require '../telegram/actions.rb'
require '../telegram/menu.rb'
require '../telegram/goose.rb'

token = '1410455276:AAEMJvxHgeqI426SHgeiQoSVwXjJ7EjU9nY'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|

    case message
    when Telegram::Bot::Types::CallbackQuery
      user = User.find_or_create_by(telegram_id: message.from.id)
      case message.data
      when 'new_game'
        Actions.create_goose(message, bot)
      when 'load_game'
        Actions.load_goose(message, bot)
      when 'menu'
        Menu.showMenu(message, bot)
      when 'goose_stats'
        Goose.show_goose(message, bot)
      else
        goose = Goose.find_by(name: message.data)
        if goose.nil?
          bot.api.send_message(chat_id: message.from.id, text: 'Неизвестная команда')
        else
          user.current_goose_name = message.data
          user.save
          Actions.show_actions(message, bot)
        end
      end
    when Telegram::Bot::Types::Message
      case message.text
      when '/start'
        Menu.showMenu(message, bot)
      else
        bot.api.send_message(chat_id: message.from.id, text: 'Неизвестная команда')
      end
    end
  end
end