class Menu
  def self.showMenu(message, bot)
    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Новая игра', callback_data: 'new_game'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Загрузить игру', callback_data: 'load_game'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Удалить все сохранения', callback_data: 'delete_all_goose'),
    ]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    bot.api.send_message(chat_id: message.from.id, text: 'Выберете действие', reply_markup: markup)
  end
end