require File.expand_path('../config/environment', __dir__)
require 'telegram/bot'
require_relative 'application'

token = '1410455276:AAEMJvxHgeqI426SHgeiQoSVwXjJ7EjU9nY'

Telegram::Bot::Client.run(token) { |bot| Application.new(bot) }
