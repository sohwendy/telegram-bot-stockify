require 'telegram/bot'
require './src/constants/constants'
require './src/constants/secrets'
require './src/command_handler'

namespace :bot do
  desc "send stock info for special user"
  task :push do
    Telegram::Bot::Client.run(TOKEN) do |bot|
      result = CommandHandler.new.charts('finance')
      bot.api.send_message(chat_id: SPECIAL_USER_ID, text: result, parse_mode: 'HTML')
    end
  end
end
