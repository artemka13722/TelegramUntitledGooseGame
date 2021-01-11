class Goose
  def self.show_goose(message, bot)
    user = User.find_or_create_by(telegram_id: message.from.id)
    goose = Goose.find_by(name: user.current_goose_name)
    bot.api.send_message(chat_id: message.from.id, text:
      "Имя:#{goose.name}
Жизнерадостность:#{goose.fun}
Мана:#{goose.mana}
Здоровье:#{goose.health}
Усталость:#{goose.weariness}
Деньги:#{goose.money}")
  end
end
