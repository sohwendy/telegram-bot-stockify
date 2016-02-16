require 'telegram/bot'
require_relative 'src/constants/constants'
require_relative 'src/constants/secrets'
require_relative 'src/command_handler'
require_relative 'src/parser/sticker_parser'
require_relative 'src/formatter'

# sticker = StickerParser.new
logger = Logger.new(LOG_PATH, Logger::DEBUG)
command = CommandHandler.new(logger)

Telegram::Bot::Client.run(TOKEN, logger: logger) do |bot|
  bot.listen do |message|
    begin
      if message.text
        result = nil
        arg = message.text.split(' ')
        arg[0].slice!(BOTNAME) if arg[0]
        if !arg[1]
          case arg[0]
            when /^\/start$/
              bot.api.send_message(chat_id: message.chat.id,
                                   text: "hi, #{message.from.first_name} #{EMOJI[:FACE_THROWING_A_KISS]}")
            when /^\/list$/
              list = command.list(arg[1])
              result = Formatter.format({type: 'list', data: list})
              bot.api.send_message(chat_id: message.chat.id, text: result || "Sorry #{message.from.first_name}, I cant find [#{arg[1]}] in /list",
                                   parse_mode: 'HTML')
            else
              bot.api.send_message(chat_id: message.chat.id,
                                   text: "2nd input required. /stat goog")
          end
        elsif arg[1].match(/^A-Za-z0-9./)
          bot.api.send_message(chat_id: message.chat.id,
                               text: "only alphabet and numbers allowed. please try again.")
        else
          case arg[0]

          when /^\/help$/
            bot.api.send_message(chat_id: message.chat.id, text: INSTRUCTION, parse_mode: 'HTML')

          when /^\/list$/
            list = command.list(arg[1])
            result = Formatter.format({type: 'list', data: list})
            bot.api.send_message(chat_id: message.chat.id, text: result || "Sorry #{message.from.first_name}, I cant find [#{arg[1]}] in /list",
                                 parse_mode: 'HTML')

          when /^\/stock$/
            result = command.stock(arg[1]) if arg[1]
            bot.api.send_message(chat_id: message.chat.id, text: result || "Sorry #{message.from.first_name}, I cant find [#{arg[1]}] in /stock",
                                 parse_mode: 'HTML')

          when /^\/charts$/
            result = command.charts(arg[1]) if arg[1]
            bot.api.send_photo(chat_id: message.chat.id, photo: File.new(CHART_IMAGE_PATH)) if result
            bot.api.send_message(chat_id: message.chat.id, text: result || "Sorry #{message.from.first_name}, I cant find [#{arg[1]}]",
                                 parse_mode: 'HTML')

          when /^\/rate$/
            result = command.rate(arg[1]) if arg[1]
            bot.api.send_message(chat_id: message.chat.id,
                                 text: result || "Sorry #{message.from.first_name}, I cant find [#{arg[1]}] in /rate",
                                 parse_mode: 'HTML')

          when /^\/stat$/
            result = command.stat(arg[1]) if arg[1]
            bot.api.send_photo(chat_id: message.chat.id, photo: File.new(CHART_IMAGE_PATH)) if result

            bot.api.send_message(chat_id: message.chat.id,
                                 text: result || "sorry #{message.from.first_name}, I cant find [#{arg[1]}] in /stat",
                                 parse_mode: 'HTML', disable_web_page_preview: true)

          else
            logger.warn("friend #{message.from.first_name} #{message.from.id} says #{message.text}")
            # bot.api.send_sticker(chat_id: message.chat.id, sticker: sticker.get_random_sticker, caption)
            bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, I dont understand #{message.text}")
          end
        end
      else
        logger.warn("stranger #{message.from.first_name} #{message.from.id} #{message.text} me")
        # bot.api.send_sticker(chat_id: message.chat.id, sticker: sticker.get_random_sticker)
        # bot.api.send_message(chat_id: message.chat.id, text: "#{EMOJI[:CONSTRUCTION_SIGN]} not ready...")
      end
    rescue Exception => e
      logger.fatal("died because #{message.from.first_name} #{message.from.id} #{message.text} >>> #{e}\n ")
    end
  end
end

