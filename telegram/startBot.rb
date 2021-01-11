require File.expand_path('../config/environment', __dir__)
require 'telegram/bot'
require '../telegram/actions.rb'
require '../telegram/menu.rb'

token = '1410455276:AAEMJvxHgeqI426SHgeiQoSVwXjJ7EjU9nY'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|

    case message
    when Telegram::Bot::Types::CallbackQuery
      case message.data
      when 'new_game'
        Actions.create_goose(message, bot)
      when 'load_game'
        Actions.load_goose(message, bot)
      when 'menu'
        Menu.showMenu(message, bot)
      else
        bot.api.send_message(chat_id: message.from.id, text: "Неизвестная команда")
      end
    when Telegram::Bot::Types::Message
      case message.text
      when '/start'
        Menu.showMenu(message, bot)
      else
        bot.api.send_message(chat_id: message.from.id, text: "Неизвестная команда")
      end
    end
  end
end