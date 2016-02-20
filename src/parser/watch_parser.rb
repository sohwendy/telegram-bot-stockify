require 'yaml'

class WatchParser
  def initialize(param)
    @path = param
    read
  end

  def add_user(user)
    @list[user] = [] if @list.size < WATCH_USERS_LIMIT && !@list.key?(user)
    write
  end

  def add(user, param)
    @list[user].push(param) if @list.key?(user) && list[user].size < WATCH_STOCKS_LIMIT
    p 'added', @list
    write
  end

  def remove(user, param)
    return unless @list.key?(user)
    if param
      @list[user].delete(param)
    else
      @list[user].clear
    end
    p 'removed', @list
    write
  end

  def list
    @list
  end

  def read
    @list = YAML.load_file @path
  end

  def write
    File.open(@path, 'w') do |file|
      file.write @list.to_yaml
    end
  end
end
