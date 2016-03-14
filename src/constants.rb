TOKEN = ENV['WATCH_TOKEN']
BOT_NAME = ENV['WATCH_BOT_NAME']

TIMEOUT = 60 # 1 minute
WATCH_USERS_LIMIT = 10
WATCH_STOCKS_LIMIT = 20

PRICE_PATH = 'http://download.finance.yahoo.com/d/quotes.csv?'.freeze
NEWS_PATH = 'https://feeds.finance.yahoo.com/rss/2.0/headline?'.freeze
STOCK_PATH = './data/stock.csv'.freeze
WATCH_PATH = './data/watch.yaml'.freeze
LOG_PATH = './tmp/errors.log'.freeze

# Refer to the links for more emoji
# http://apps.timwhitlock.info/emoji/tables/unicode
# https://github.com/AxeLFFF/telegram-mems-bot/tree/master/telegram
class Emoji
  FACE_THROWING_A_KISS = "\xF0\x9F\x98\x98".freeze
  OK_HAND_SIGN = "\xF0\x9F\x91\x8C".freeze
  CHART_WITH_UPWARDS_TREND = "\xF0\x9F\x93\x88".freeze
  CHART_WITH_DOWNWARDS_TREND = "\xF0\x9F\x93\x89".freeze
  FACE_WITH_NO_GOOD_GESTURE = "\xF0\x9F\x99\x85".freeze
  HEAVY_MINUS_SIGN = "\xE2\x9E\x96".freeze
  FOUR_LEAF_CLOVER = "\xF0\x9F\x8D\x80".freeze
  SEE_NO_EVIL_MONKEY = "\xF0\x9F\x99\x88".freeze
  HEAR_NO_EVIL_MONKEY = "\xF0\x9F\x99\x89".freeze
  SPEAK_NO_EVIL_MONKEY = "\xF0\x9F\x99\x8A".freeze
  MONKEYS = SEE_NO_EVIL_MONKEY + HEAR_NO_EVIL_MONKEY + SPEAK_NO_EVIL_MONKEY

  def self.trend(value)
    if value > 0
      CHART_WITH_UPWARDS_TREND
    elsif value < 0
      CHART_WITH_DOWNWARDS_TREND
    else
      HEAVY_MINUS_SIGN
    end
  end
end

class Reply
  OBJECTIVE = 'i fetch finance data from yahoo'.freeze
  INSTRUCTION = "\n
  /subscribe - start receiving notification on stock
  /unsubscribe - stop receiving notification
  /add <ticker> - add a stock to your watchlist. try /add S68.SI
  /remove <ticker> - remove the stock from your watchlist. try /remove S68.SI
  /clear - clear your watchlist
  /list - retrieve your watchlist".freeze

  SUBSCRIBE_OK = 'subscribed! Now /add <a stock ticker>'.freeze
  SUBSCRIBE_AGAIN = 'thanks for renewing your support'.freeze
  UNSUBSCRIBE_OK = 'bye! hope to hear from you again'.freeze
  UNSUBSCRIBE_FAIL = 'not subscribed, not unsubscribing'.freeze
  AUTHENTICATE_FAIL = '/subscribe to me first'.freeze
  MAX_USERS = 'max users reached'.freeze
  MAX_STOCKS = 'max stock added'.freeze
  REMOVE_FAIL = 'stock has not been added'.freeze
  STOCK_NOT_FOUND = 'stock cant be found'.freeze
  CLEAR_OK = '/add <a stock ticker>'.freeze
  NOT_WATCHING = 'you are not watching'.freeze
  WATCHING = 'you are watching'.freeze

  def self.exception(name, id, msg, e)
    "killed by #{name} #{id} #{msg} #{e}\n"
  end

  def self.negative(name, param, cmd)
    "sorry #{name}, i cant find [#{param}] in /#{cmd}"
  end

  def self.invalid_command(emoji, msg)
    "#{emoji} #{msg} not found"
  end

  def self.invalid_param(emoji, msg)
    "#{emoji} #{msg} not valid. type only alphabet, number and ."
  end
end

COMMAND = { start:
                    { valid_param: false },
            help:
                    { valid_param: false },
            stat:
                    { valid_param: true, photo: true, msg: { parse_mode: 'HTML', disable_web_page_preview: true } },
            subscribe:
                    { valid_param: false, msg: {} },
            unsubscribe:
                    { valid_param: false, msg: {} },
            add:
                    { valid_param: true, msg: {} },
            remove:
                    { valid_param: true, msg: {} },
            clear:
                    { valid_param: false, msg: {} },
            list:
                    { valid_param: false, msg: {} }
        }.freeze
