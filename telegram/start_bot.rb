require File.expand_path('../config/environment', __dir__)
require 'telegram/bot'
require_relative 'application'

token = '1530468536:AAHvraAH0BS8rA9En3ojC56hqsJ1xPbXgio'

Telegram::Bot::Client.run(token) { |bot| Application.new(bot) }
