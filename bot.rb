require 'telegram/bot'
require_relative 'src/constants/constants'
require_relative 'src/constants/secrets'
require_relative 'src/command_handler'

logger = Logger.new(LOG_PATH, Logger::DEBUG)
command = CommandHandler.new

COMMAND = {'start' => false, 'help' => false, 'list' => false, 'stock' => true,
           'rate' => true, 'charts' => true, 'stat' => true}

Telegram::Bot::Client.run(TOKEN, logger: logger) do |bot|
  bot.listen do |message|
    begin
      logger.info("#{message.from.first_name} #{message.from.id}  says #{message.text}...")
      unless message.text
        bot.api.send_message(chat_id: message.chat.id, text: INSTRUCTION)
        return
      end

      result = nil
      arg = message.text.split(' ')
      arg[0].slice!(BOT_NAME)

      cmd = arg[0] ? arg[0][1..-1] : nil
      param = arg[1] && arg[1].match(/^[A-Za-z0-9.]+$/) ? arg[1] : nil

      unless COMMAND.include?(cmd)
        return bot.api.send_message(chat_id: message.chat.id, text: invalid_command_reply(arg[0]))
      end

      if COMMAND[cmd] && param.nil?
        return bot.api.send_message(chat_id: message.chat.id, text: invalid_param_reply(arg[1]))
      end

      case cmd
        when 'help'
          bot.api.send_message(chat_id: message.chat.id,
                               text: INSTRUCTION)

        when 'list'
          result = command.list(param)
          bot.api.send_message(chat_id: message.chat.id,
                               text: result || negative_reply(message.from, param, cmd),
                               parse_mode: 'HTML')
        when 'stock'
          result = command.stock(param)
          bot.api.send_message(chat_id: message.chat.id,
                               text: result || negative_reply(message.from, param, cmd),
                               parse_mode: 'HTML')

        when 'charts'
          result = command.charts(param)
          bot.api.send_photo(chat_id: message.chat.id, photo: File.new(CHART_IMAGE_PATH)) if result
          bot.api.send_message(chat_id: message.chat.id,
                               text: result || negative_reply(message.from, param, cmd),
                               parse_mode: 'HTML')

        when 'rate'
          result = command.rate(param)
          bot.api.send_message(chat_id: message.chat.id,
                               text: result || negative_reply(message.from, param, cmd),
                               parse_mode: 'HTML')

        when 'stat'
          result = command.stat(param)
          bot.api.send_photo(chat_id: message.chat.id,
                             photo: File.new(CHART_IMAGE_PATH)) if result

          bot.api.send_message(chat_id: message.chat.id,
                               text: result || negative_reply(message.from, param, cmd),
                               parse_mode: 'HTML',
                               disable_web_page_preview: true)
        else
          bot.api.send_message(chat_id: message.chat.id,
                               text: welcome_reply(message.from))

      end
    rescue Exception => e
      logger.fatal(exception_log(message.from, message.text, e))
    end
  end
end

