require_relative 'api_handler'
require_relative 'constants/constants'
require_relative 'parser/stock_parser'
require_relative 'parser/currency_parser'
require_relative 'formatter'

class CommandHandler
  def initialize(param)
    @logger = param
    @currency = CurrencyParser.new(CURRENCY_PATH)
    @stock = StockParser.new(STOCK_PATH)
  end

  def list(param)
    @stock.get_list(param)
  end

  def charts(param)
    ticker_hash = @stock.get_from_tags(param)

    if (ticker_hash && ticker_hash.length > 0)
      ApiHandler.get_chart(ticker_hash.keys.join(','))
      data = ApiHandler.get_price(ticker_hash.keys.join(','))
      data.each_key { |key| data[key].merge!(ticker_hash[key]) }
      result = Formatter.format({type: 'price', data: data})
    end

    result
  end

  def rate(param)
    param = @currency.validate_and_format(param)
    if param
      data = ApiHandler.get_currency(param)
      result = Formatter.format({type: 'currency', data: data}) + ApiHandler.get_preview(param.concat('=x'))
    end
    result
  end

  def stat(param)
    param.upcase!
    ticker_hash = @stock.get_from_symbol(param)
    ApiHandler.get_chart(param)
    data = ApiHandler.get_stat(param)
    if data && data.values && data.values.size > 0
      data.each_key { |key| data[key].merge!(ticker_hash[key]) } unless ticker_hash.empty?
      result = Formatter.format({type: 'stat', data: data})
    end
    result
  end

  def stock(param)
    ticker_hash = @stock.get_from_symbol(param)
    if (ticker_hash.keys.length == 0)
      ticker_hash = { param => {}}
    end
    data = ApiHandler.get_price(ticker_hash.keys.first)
    unless data.empty?
      data = data.each_key { |key| data[key].merge!(ticker_hash[key]) }
      result = Formatter.format({type: 'price', data: data})
    end
    result
  end
end

