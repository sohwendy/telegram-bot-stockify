require 'telegram/bot'
require_relative 'src/constants/constants'
require_relative 'src/constants/secrets'
require_relative 'src/command_handler'

logger = Logger.new(LOG_PATH, Logger::DEBUG)
command = CommandHandler.new

Telegram::Bot::Client.run(TOKEN, logger: logger) do |bot|
  bot.listen do |message|
    begin
      logger.info("#{message.from.first_name} #{message.from.id} says #{message.text}...")

      # process the params
      arg = message.text.split(' ')
      arg[0].slice!(BOT_NAME)
      cmd = arg[0] ? arg[0][1..-1] : nil
      param = arg[1] && arg[1].match(/^[A-Za-z0-9.]+$/) ? arg[1] : nil

      # validatio
      next if DateTime.now.to_time.to_i - message.date > TIMEOUT

      unless message.text
        bot.api.send_message(chat_id: message.chat.id, text: INSTRUCTION)
        break
      end

      unless COMMAND.keys.include?(cmd.to_sym)
        bot.api.send_message(chat_id: message.chat.id,
                             text: invalid_command_reply(arg[0]))
        break
      end

      if COMMAND.dig(cmd.to_sym, :valid_param) && param.nil?
        bot.api.send_message(chat_id: message.chat.id, text: invalid_param_reply(arg[1]))
        break
      end

      # grab data from api
      case cmd
      when 'help'
        bot.api.send_message(chat_id: message.chat.id, text: INSTRUCTION)
      when 'start'
          bot.api.send_message(chat_id: message.chat.id, text: welcome_reply(message.from))
      else
        if command.respond_to?(cmd, param)
          result = command.send(cmd, param)

          if result && COMMAND.dig(cmd.to_sym, :photo)
            bot.api.send_photo(chat_id: message.chat.id, photo: File.new(CHART_IMAGE_PATH))
          end

          bot.api.send_message(chat_id: message.chat.id,
                               text: result || negative_reply(message.from, param, cmd),
                               **COMMAND.dig(cmd.to_sym, :msg))
        end
      end
    rescue StandardError => e
      logger.fatal(exception_log(message.from, message.text, e))
    end
  end
end
