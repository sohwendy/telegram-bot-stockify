require 'telegram/bot'
require './src/constants/constants'
require './src/constants/secrets'
require './src/command_handler'

namespace :bot do
  desc 'send stock info'
  task :push do
    Telegram::Bot::Client.run(TOKEN) do |bot|
      command = CommandHandler.new
      WatchParser.new(WATCH_PATH).list.each_pair do |key, value|
        param = {}
        if value.nil?
          result = "you are not watching any stock\n"
        else
          result = "you are receiving auto notification \n\n"
          value.each { |val| param.merge!(val => {}) }
          result << command.stocks(param: param)
        end
        result << "\n refer to /help for instruction on watching"
        bot.api.send_message(chat_id: key, text: result, parse_mode: 'HTML')
      end
    end
  end
end
