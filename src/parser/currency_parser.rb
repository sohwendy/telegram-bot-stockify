class CurrencyParser
  def initialize(param)
    array = []
    CSV.foreach(param) { |row| array << [row[0].downcase!, row[1]] }
    @code_hash = array.to_h

    @list = ''
    @code_hash.each_pair do |key, value|
      @list.concat("#{key}   #{value}\n")
    end
  end

  def validate_and_format(param)
    param.downcase!
    case param.length
    when 3
      return @code_hash.keys.include?(param.slice(0, 3)) ? param.concat('sgd') : nil
    when 6
      return @code_hash.keys.include?(param.slice(0, 3)) && @code_hash.keys.include?(param.slice(3, 6)) ? param : nil
    end
    nil
  end
end
