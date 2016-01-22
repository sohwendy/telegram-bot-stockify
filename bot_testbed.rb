
require 'telegram/bot'
require_relative 'src/constants/constants'
require_relative 'src/constants/secrets'
require_relative 'src/command_handler'

logger = Logger.new(File.new(LOG_PATH,'w'), Logger::DEBUG)
c = CommandHandler.new(logger)

# --------------------------------------------
#                     list
# --------------------------------------------
# p c.list('')
# p c.list('REIT')
p c.list('bank')
# --------------------------------------------
#                     rate
# --------------------------------------------
# p c.rate('usdsgd')
# --------------------------------------------
#                     charts
# --------------------------------------------
# p c.charts('Singapore')
# p c.charts('REIT')
# p c.charts('')
# p c.charts('finance')
# p c.charts('s68.si')
# --------------------------------------------
#                     stock
# --------------------------------------------
# p c.stock('S68.SI')
# p c.stock('Singapore')
# p c.stock('goog')
# p c.stock('S68.SI')
# p c.stock('')
# --------------------------------------------
#                     stat
# --------------------------------------------
# p c.stat('S68.SI')
# p c.stat('and')
# p c.stat('bn54.si')
# p c.stat('singapore')
# p c.stat('')

