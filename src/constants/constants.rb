CHART_PATH = 'http://chart.finance.yahoo.com/z?'.freeze
PRICE_PATH = 'http://download.finance.yahoo.com/d/quotes.csv?'.freeze
NEWS_PATH = 'https://feeds.finance.yahoo.com/rss/2.0/headline?'.freeze
CURRENCY_PATH = './data/currency.csv'.freeze
STOCK_PATH = './data/stock.csv'.freeze
CHART_IMAGE_PATH = './tmp/chart.jpg'.freeze
LOG_PATH = './tmp/errors.log'.freeze

INSTRUCTION = "i fetch finance data from yahoo \n
Commands:
/list - gives stocks available in this bot
/rate - get currency rate and chart using 3-digit currency code /rate usdeur
/stock - states the last traded price of *one* stock counter /stock Z78.SI
/charts - (expert mode) depicts the graphical %change of some of the matching SG stocks and STI /charts bank
/stat - (expert mode) provides details about the stock counter /stat GOOG".freeze

def welcome_reply(caller)
  "hi, #{caller.first_name} #{Emoji::FACE_THROWING_A_KISS}"
end

def negative_reply(caller, param, cmd)
  "sorry #{caller.first_name}, i cant find [#{param}] in /#{cmd}"
end

def exception_log(caller, msg, e)
  "killed by #{caller.first_name} #{caller.id} #{msg}:\n #{e}\n"
end

def invalid_command_reply(msg)
  "#{Emoji::SEE_NO_EVIL_MONKEY} #{Emoji::HEAR_NO_EVIL_MONKEY} #{Emoji::SPEAK_NO_EVIL_MONKEY}  #{msg} not found"
end

def invalid_param_reply(msg)
  "#{Emoji::FACE_WITH_NO_GOOD_GESTURE} #{msg} not valid. only alphabet, number and . allowed"
end

# Refer to the links for more emoji
# http://apps.timwhitlock.info/emoji/tables/unicode
# https://github.com/AxeLFFF/telegram-mems-bot/tree/master/telegram
class Emoji
  FACE_THROWING_A_KISS = "\xF0\x9F\x98\x98".freeze
  BEAR_FACE = "\xF0\x9F\x90\xBB".freeze
  COW_FACE = "\xF0\x9F\x90\xAE".freeze
  CHART_WITH_UPWARDS_TREND = "\xF0\x9F\x93\x88".freeze
  CHART_WITH_DOWNWARDS_TREND = "\xF0\x9F\x93\x89".freeze
  HEAVY_MINUS_SIGN = "\xE2\x9E\x96".freeze
  SEE_NO_EVIL_MONKEY = "\xF0\x9F\x99\x88".freeze
  HEAR_NO_EVIL_MONKEY = "\xF0\x9F\x99\x89".freeze
  SPEAK_NO_EVIL_MONKEY = "\xF0\x9F\x99\x8A".freeze
end
