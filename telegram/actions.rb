class Actions
  def self.show_actions(message, bot)
    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '1 действие', callback_data: 'action1'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '2 действие', callback_data: 'action2'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Меню', callback_data: 'menu'),
    ]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    bot.api.send_message(chat_id: message.from.id, text: 'Выберете действие', reply_markup: markup)
  end

  def self.create_goose(message, bot)
    user = User.find_or_create_by(telegram_id: message.from.id)
    bot.api.send_message(chat_id: message.from.id, text: 'Введите имя гуся')

    bot.listen do |message|
      user.goose.create(name: message.text, fun: 0, mana: 0, health: 100, weariness: 0, money: 0)
      user.save
      break
    end
    show_actions(message, bot)
  end

  def self.load_goose(message, bot)
    user = User.find_or_create_by(telegram_id: message.from.id)

    user.goose.each do | gos |
      bot.api.send_message(chat_id: message.from.id, text: "#{gos.name}")
    end
  end
end
