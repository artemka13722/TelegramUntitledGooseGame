class View
  def self.button(text, callback_data)
    Telegram::Bot::Types::InlineKeyboardButton.new(text: text, callback_data: callback_data)
  end

  def self.markup(inline_keyboard)
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: inline_keyboard)
  end
end
