require_relative 'constants/constants'
require_relative 'parser/stock_parser'
require_relative 'parser/currency_parser'
require_relative 'api_helper'
require_relative 'format_helper'

class CommandHandler
  include FormatHelper
  include ApiHelper

  def initialize
    @currency = CurrencyParser.new(CURRENCY_PATH)
    @stock = StockParser.new(STOCK_PATH)
  end

  def list(param)
    format(type: 'list', data: @stock.get_list(param))
  end

  def charts(param)
    ticker_hash = @stock.get_from_tags(param)

    if ticker_hash && !ticker_hash.empty?
      get_chart(ticker_hash.keys.join(','))
      data = get_price(ticker_hash.keys.join(','))
      data.each_key { |key| data[key].merge!(ticker_hash[key]) }
      result = format(type: 'price', data: data)
    end

    result
  end

  def rate(param)
    param = @currency.validate_and_format(param)
    result = format(type: 'currency', data: get_currency(param)) + get_preview(param.concat('=x')) if param
    result
  end

  def stat(param)
    param.upcase!
    ticker_hash = @stock.get_from_symbol(param)
    get_chart(param)
    data = get_stat(param)
    if data && !data.empty?
      data.each_key { |key| data[key].merge!(ticker_hash[key]) } unless ticker_hash.empty?
      result = format(type: 'stat', data: data)
    end

    result
  end

  def stock(param)
    ticker_hash = @stock.get_from_symbol(param)
    ticker_hash = { param => {} } if ticker_hash.empty?
    data = get_price(ticker_hash.keys.first)
    unless data.empty?
      data = data.each_key { |key| data[key].merge!(ticker_hash[key]) }
      result = format(type: 'price', data: data)
    end

    result
  end

  def watch(param)
  end

  def unwatch(param)
  end

  def watch_list(param)
  end

  def watch_clear(param)
  end
end
