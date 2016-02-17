CHART_PATH = 'http://chart.finance.yahoo.com/z?'
PRICE_PATH = 'http://download.finance.yahoo.com/d/quotes.csv?'
NEWS_PATH = 'https://feeds.finance.yahoo.com/rss/2.0/headline?'
CURRENCY_PATH = './data/currency.csv'
STOCK_PATH = './data/stock.csv'
CHART_IMAGE_PATH = './tmp/chart.jpg'
LOG_PATH = './tmp/errors.log'

MAX_STOCK = 15

INSTRUCTION = "i fetch finance data from yahoo \n
Commands:
/list - gives stocks available in this bot
/rate - get currency rate and chart using 3-digit currency code /rate usdeur
/stock - states the last traded price of *one* stock counter /stock Z78.SI
/charts - (expert mode) depicts the graphical %change of some of the matching SG stocks and STI /charts bank
/stat - (expert mode) provides details about the stock counter /stat GOOG"

def welcome_reply(caller)
  "hi, #{caller.first_name} \xF0\x9F\x98\x98"
end

def negative_reply(caller, param, cmd)
  "sorry #{caller.first_name}, i cant find [#{param}] in /#{cmd}"
end

def exception_log(caller, msg, e)
  "killed by #{caller.first_name} #{caller.id} #{msg}:\n #{e}\n "
end

