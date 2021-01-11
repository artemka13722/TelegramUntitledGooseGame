require '../telegram/goose.rb'

class Actions
  def self.show_actions(message, bot)
    Goose.show_goose(message, bot)
    kb = []
    Action.all.each do |action|
      kb.push(Telegram::Bot::Types::InlineKeyboardButton.new(text: "#{action.name_show}", callback_data: "#{action.name_action}"))
    end
    kb.push(Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Меню', callback_data: 'menu'))
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    bot.api.send_message(chat_id: message.from.id, text: 'Выберете действие', reply_markup: markup)
  end

  def self.create_goose(message, bot)
    user = User.find_or_create_by(telegram_id: message.from.id)
    bot.api.send_message(chat_id: message.from.id, text: 'Введите имя гуся')
    bot.listen do |message|
      goose = Goose.find_by(name: message.text)
      if goose.nil?
        user.goose.create(name: message.text, fun: 0, mana: 0, health: 100, weariness: 0, money: 0)
        user.current_goose_name = message.text
        user.save
        break
      else
        bot.api.send_message(chat_id: message.from.id, text: 'Данное имя уже занято. Придумайте другое')
      end
    end
    show_actions(message, bot)
  end

  def self.load_goose(message, bot)
    user = User.find_or_create_by(telegram_id: message.from.id)
    kb = []
    user.goose.each do | gos |
      kb.push(Telegram::Bot::Types::InlineKeyboardButton.new(text: "#{gos.name}", callback_data: "#{gos.name}"))
    end
    kb.push(Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Меню', callback_data: 'menu'))
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    if user.goose.empty?
      bot.api.send_message(chat_id: message.from.id, text: 'Гусей не найдено :(', reply_markup: markup)
    else
      bot.api.send_message(chat_id: message.from.id, text: 'Выберете гуся', reply_markup: markup)
    end
  end
end
