require 'telegram/bot'
require './src/constants'
require './src/watch_handler'

namespace :bot do
  desc 'send stock info'
  task :push do
    Telegram::Bot::Client.run(TOKEN) do |bot|
      watch = WatchHandler.new(WATCH_PATH)
      time = Time.now.strftime('%l:%M%P %e-%b')
      subscribers = watch.notify
      if subscribers && !subscribers.empty?
        subscribers.each_pair do |key, value|
          if value
            result = "#{Emoji::FOUR_LEAF_CLOVER} you are receiving auto notification #{time}\n\n"
            result << value
          else
            result = "#{Emoji::FOUR_LEAF_CLOVER} you are not watching any stock #{time}\n\n"
          end
          result << '/help for more info'
          bot.api.send_message(chat_id: key, text: result)
        end
      else
        p 'no subscriber'
      end
    end
  end
end
