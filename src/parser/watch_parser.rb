require 'yaml'

class WatchParser
  def initialize(param)
    @path = param
    read
  end

  def add_user(user)
    if @list.size < WATCH_USERS_LIMIT && !@list.key?(user)
      @list[user] = []
      write
      return true
    end
    nil
  end

  def add(user, param)
    return { status: 'not allowed' } unless @list.key?(user)
    return { status: 'max 10 can be added' } if list[user].size >= WATCH_STOCKS_LIMIT
    @list[user].unshift(param.downcase).uniq!
    write
    { status: 'Done', param: @list[user].join(', ') }
  end

  def remove(user, param)
    return { status: 'not allowed' } unless @list.key?(user)

    @list[user].delete(param)
    write
    { status: 'Done', param: @list[user].join(', ') }
  end

  def clear(user)
    return { status: 'not allowed' } unless @list.key?(user)

    @list[user].clear
    write
    { status: 'Done', param: I18n.t('watch_nothing_reply') }
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
