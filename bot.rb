require 'telegram/bot'
require_relative 'src/constants'
require_relative 'src/watch_handler'

logger = Logger.new(STDOUT)
watch = WatchHandler.new(WATCH_PATH)

Telegram::Bot::Client.run(TOKEN, logger: logger) do |bot|
  bot.listen do |message|
    begin
      logger.info("#{message.from.first_name} of #{message.from.id},#{message.chat.id} says #{message.text}...")

      # process the params
      arg = message.text.split(' ')
      arg[0].slice!(BOT_NAME)
      cmd = arg[0] ? arg[0][1..-1] : nil
      param = arg[1] && arg[1].match(/^[A-Za-z0-9.]+$/) ? arg[1].upcase : nil
      name = message.from.first_name

      # validation
      if DateTime.now.to_time.to_i - message.date > TIMEOUT
      elsif !message.text
        bot.api.send_message(chat_id: message.chat.id, text: Reply::INSTRUCTION)
      elsif !COMMAND.key?(cmd.to_sym)
        bot.api.send_message(chat_id: message.chat.id,
                             text: Reply.invalid_command(Emoji::FACE_WITH_NO_GOOD_GESTURE, arg[0]))
        bot.api.send_message(chat_id: message.chat.id, text: Reply::INSTRUCTION)
      elsif COMMAND.dig(cmd.to_sym, :valid_param) && param.nil?
        bot.api.send_message(chat_id: message.chat.id,
                             text: Reply.invalid_param(Emoji::MONKEYS, arg[1]))
        bot.api.send_message(chat_id: message.chat.id, text: Reply::INSTRUCTION)
      elsif cmd == 'start'
        bot.api.send_message(chat_id: message.chat.id, text: Reply::OBJECTIVE + '\n' + Reply::INSTRUCTION)
      elsif watch.respond_to?(cmd, param: param, user: message.chat.id)
        result = watch.send(cmd, param: param, user: message.chat.id)

        bot.api.send_message(chat_id: message.chat.id,
                             text: result || Reply.negative(name, param, cmd),
                             **COMMAND.dig(cmd.to_sym, :msg))
        bot.api.send_message(chat_id: message.chat.id, text: Reply::INSTRUCTION) unless result
      else
        bot.api.send_message(chat_id: message.chat.id, text: Reply::INSTRUCTION)
      end
    rescue Exception => e
      logger.fatal(Reply.exception(message.from.first_name, message.from.id, message.text, e))
    end
  end
end
