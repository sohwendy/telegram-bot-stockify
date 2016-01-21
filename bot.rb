require 'telegram/bot'
require_relative 'src/constants/constants'
require_relative 'src/constants/secrets'
require_relative 'src/command_handler'
require_relative 'src/parser/stock_parser'
require_relative 'src/parser/currency_parser'
require_relative 'src/parser/sticker_parser'
require_relative 'src/formatter'

currency = CurrencyParser.new(CURRENCY_PATH)
stock = StockParser.new(STOCK_PATH)
sticker = StickerParser.new
logger = Logger.new(LOG_PATH, Logger::DEBUG)

Telegram::Bot::Client.run(TOKEN, logger: logger) do |bot|
  bot.listen do |message|
    begin
      if message.text && MEMBERS.include?(message.from.id.to_s)
        result = nil
        arg = message.text.split(' ')
        case arg[0]
        when /^\/start/
          bot.api.send_message(chat_id: message.chat.id,
                               text: "hi, #{message.from.first_name} #{EMOJI[:FACE_THROWING_A_KISS]}")

        when /^\/help/
          bot.api.send_message(chat_id: message.chat.id, text: INSTRUCTION, parse_mode: 'Markdown')

        when /^\/list/
          bot.api.send_message(chat_id: message.chat.id, text: stock.get_list(arg[1]), parse_mode: 'Markdown')

        when /^\/stock/
          ticker_hash = stock.get_from_symbol(arg[1])
          if (ticker_hash.keys.length == 0)
            ticker_hash = { arg[1] => {}}
          end
          data = CommandHandler.get_price(ticker_hash.keys.first)
          unless data.empty?
            data = data.each_key { |key| data[key].merge!(ticker_hash[key]) }
            result = Formatter.format({type: 'price', data: data})
          end
          bot.api.send_message(chat_id: message.chat.id, text: result || "Sorry #{message.from.first_name}, I cant find #{arg[1]}", parse_mode: 'Markdown')

        when /^\/charts/
          if arg[1]
            ticker_hash = stock.get_from_tags(arg[1])

            if (ticker_hash && ticker_hash.length > 0)
              CommandHandler.get_chart(ticker_hash.keys.join(','))
              data = CommandHandler.get_price(ticker_hash.keys.join(','))
              data.each_key { |key| data[key].merge!(ticker_hash[key]) }
              result = Formatter.format({type: 'price', data: data})
              bot.api.send_photo(chat_id: message.chat.id, photo: File.new(CHART_IMAGE_PATH))
            end
          end
          bot.api.send_message(chat_id: message.chat.id, text: result || "sorry #{message.from.first_name}, I cant find #{message.text}")


        when /^\/rate/
          if arg[1]
            param = currency.validate_and_format(arg[1])
            if param
              data = CommandHandler.get_currency(param)
              result = Formatter.format({type: 'currency', data: data}) + CommandHandler.get_preview(param.concat('=x'))
            end
          end
          bot.api.send_message(chat_id: message.chat.id,
                               text: result || "sorry #{message.from.first_name}, I cant find #{message.text}",
                               parse_mode: 'Markdown')

        when /^\/stat/
          if arg[1]
            ticker_hash = stock.get_from_symbol(arg[1])
            CommandHandler.get_chart(arg[1].upcase)
            data = CommandHandler.get_stat(arg[1].upcase)
            if data && data.values && data.values.size > 0
              bot.api.send_photo(chat_id: message.chat.id, photo: File.new(CHART_IMAGE_PATH))
              data.each_key { |key| data[key].merge!(ticker_hash[key]) } unless ticker_hash.empty?
              result = Formatter.format({type: 'stat', data: data})
            end
          end
          bot.api.send_message(chat_id: message.chat.id,
                               text: result || "sorry #{message.from.first_name}, I cant find #{message.text}",
                               parse_mode: 'Markdown', disable_web_page_preview: true)

        else
          logger.warn("friend #{message.from.first_name} #{message.from.id} says #{message.text}")
          # bot.api.send_sticker(chat_id: message.chat.id, sticker: sticker.get_random_sticker, caption)
          bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, I dont understand #{message.text}")
        end

      else
        logger.warn("stranger #{message.from.first_name} #{message.from.id} #{message.text} me")
        # bot.api.send_sticker(chat_id: message.chat.id, sticker: sticker.get_random_sticker)
        # bot.api.send_message(chat_id: message.chat.id, text: "#{EMOJI[:CONSTRUCTION_SIGN]} not ready...")
      end
    rescue
      logger.fatal("died because #{message.from.first_name} #{message.from.id} #{message.text} \n #{message.text}\n")
    end
  end
end

