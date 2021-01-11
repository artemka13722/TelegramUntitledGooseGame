require File.expand_path('../config/environment', __dir__)
require 'telegram/bot'
require_relative 'application'

token = '975405113:AAFEApDrmD5wyUtNlbMM7Zeu7sWFNxYnhT8'

Telegram::Bot::Client.run(token) { |bot| Application.new(bot) }
