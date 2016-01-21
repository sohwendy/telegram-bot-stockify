CHART_PATH = 'http://chart.finance.yahoo.com/z?'
PRICE_PATH = 'http://download.finance.yahoo.com/d/quotes.csv?'
NEWS_PATH = 'http://finance.yahoo.com/rss/headline?'
CURRENCY_PATH = './data/currency.csv'
STOCK_PATH = './data/stock.csv'
CHART_IMAGE_PATH = './tmp/chart.jpg'
LOG_PATH = './tmp/errors.log'

MAX_STOCK = 15

INSTRUCTION = "i fetch finance data from yahoo \n
Commands:
/list - gives stocks available in this bot
/rate - get currency rate and chart using 3-digit currency code /rate usdeur
/charts - (expert mode) depicts the graphical %change of some of the matching SG stocks and STI /chart bank
/stock - states the last traded price of *one* stock counter /price Z78.SI
/stat - (expert mode) lists some SG stocks matching the given name /chart bank"

