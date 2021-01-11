require_relative 'view'

class Screen
  def self.show_start_menu(message, bot)
    menu_bottoms = [
      View.button('Новая игра', 'start_menu_new_game'),
      View.button('Загрузить игру', 'start_menu_load_game'),
      View.button('Удалить все сохранения', 'start_menu_delete_all_goose')
    ]

    bot.api.send_message(chat_id: message.from.id, text: 'Выберете действие', reply_markup: View.markup(menu_bottoms))
  end

  def self.show_menu_level(message, bot)
    menu_bottoms = [
      View.button('Легкий', 'menu_level_easy'),
      View.button('Средний', 'menu_level_middle'),
      View.button('Высокий', 'menu_level_hard')
    ]

    bot.api.send_message(chat_id: message.from.id, text: 'Выберете уровень', reply_markup: View.markup(menu_bottoms))
  end

  def self.show_geese(id, bot, geese)
    menu_bottoms = []
    geese.each { |goose| menu_bottoms.push(View.button(goose.name.to_s, goose.name.to_s)) }
    menu_bottoms.push(View.button('Меню', 'start_menu'))
    if geese.empty?
      bot.api.send_message(
        chat_id: id,
        text: 'Гусей не найдено :(',
        reply_markup: View.markup(menu_bottoms)
      )
    else
      bot.api.send_message(
        chat_id: id,
        text: 'Выберете гуся',
        reply_markup: View.markup(menu_bottoms)
      )
    end
  end

  def self.show_goose(message, bot, goose)
    show_toast(
      message,
      bot,
      "Имя: #{goose.name}
Уровень: #{goose.level}
Состояние: #{goose.alive ? 'Здоров' : 'RIP'}
Жизнерадостность: #{goose.fun}
Мана: #{goose.mana}
Здоровье: #{goose.health}
Усталость: #{goose.weariness}
Деньги: #{goose.money}"
    )
  end

  def self.show_toast(message, bot, text)
    bot.api.send_message(chat_id: message.from.id, text: text)
  end

  def self.show_actions(message, bot, actions)
    menu_bottoms = []
    actions.each { |action| menu_bottoms.push(View.button(action.name_show.to_s, "action_#{action.name_action}")) }
    menu_bottoms.push(View.button('Меню', 'game_menu'))
    bot.api.send_message(chat_id: message.from.id, text: 'Выберете действие', reply_markup: View.markup(menu_bottoms))
  end
end
