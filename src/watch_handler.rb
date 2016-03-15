require 'yaml'
require_relative 'parser/stock_parser'
require_relative 'constants'
require_relative 'api_helper'
require_relative 'format_helper'

class WatchHandler
  include ApiHelper
  include FormatHelper

  def initialize(param)
    @stock = StockParser.new(STOCK_PATH)
    @path = param
    read
  end

  def subscribe(options = {})
    user = options[:user]

    return "#{Reply::SUBSCRIBE_AGAIN} \n#{list(options)}" if @list.key?(user)
    return Reply::MAX_USERS if @list.size >= WATCH_USERS_LIMIT

    @list[user] = {}
    write
    Reply::SUBSCRIBE_OK
  end

  def unsubscribe(options = {})
    user = options[:user]

    return Reply::UNSUBSCRIBE_FAIL unless @list.key?(user)

    @list.delete(user)
    write
    Reply::UNSUBSCRIBE_OK
  end

  def add(options = {})
    user = options[:user]
    param = options[:param]

    return Reply::AUTHENTICATE_FAIL unless @list.key?(user)
    return Reply::MAX_STOCKS if @list[user].size >= WATCH_STOCKS_LIMIT

    result = validate(param)
    return Reply::STOCK_NOT_FOUND unless result

    @list[user].merge!(result)
    write
    "added #{param}! \n\n#{retrieve(user)}"
  end

  def remove(options = {})
    user = options[:user]
    param = options[:param]

    return Reply::AUTHENTICATE_FAIL unless @list.key?(user)
    return Reply::REMOVE_FAIL unless @list.dig(user, param)

    @list[user].delete(param)
    write

    "#{param} removed! \n\n#{retrieve(user)}"
  end

  def clear(options = {})
    user = options[:user]

    return Reply::AUTHENTICATE_FAIL unless @list.key?(user)

    @list[user].clear
    write
    Reply::CLEAR_OK
  end

  def notify
    result = {}
    return nil unless @list
    @list.each_key do |user|
      result[user] = retrieve(user)
    end
    result
  end

  def list(options = {})
    user = options[:user]

    return Reply::AUTHENTICATE_FAIL unless @list.key?(user)
    return Reply::CLEAR_OK unless @list[user]

    result = retrieve(user)

    result ? "#{Reply::WATCHING} \n\n#{result}" : Reply::CLEAR_OK
  end

  def validate(param)
    ticker_hash = @stock.get_from_symbol(param)
    ticker_hash = { param => {} } if ticker_hash.empty?
    data = get_price(param)
    if !data || data.empty?
      nil
    else
      { param => (ticker_hash.dig(param, :name) || data.dig(param, :name)) }
    end
  end

  private

  def get_stocks(param)
    data = get_price(param.keys.join(','))
    if data.empty?
      nil
    else
      data.each_pair { |key, value| value[:name] = param[key] }
    end
  end

  def retrieve(user)
    stock_list = @list[user]
    return nil if !stock_list || stock_list.empty?
    hash = get_stocks(stock_list)
    return "#{format_price(hash)}\n" if hash
  end

  def read
    @list = (YAML.load_file @path) || {}
  end

  def write
    File.open(@path, 'w') { |file| file.write @list.to_yaml }
  end
end
