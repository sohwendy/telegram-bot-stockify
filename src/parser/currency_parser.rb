class CurrencyParser

  def initialize(param)
    array = []
    CSV.foreach(param) { |row| array << [row[0].downcase!, row[1]] }
    @parser_hash = array.to_h

    @list = ''
    @parser_hash.each_pair do |key, value|
      @list.concat("#{key}   #{value}\n")
    end
  end

  def get_list
    @list
  end

  def validate_and_format(param)
    param.downcase!
    case param.length
      when 3
        @parser_hash.keys.include?(param.slice(0, 3)) ? param.concat('sgd') : nil
        when 6
        @parser_hash.keys.include?(param.slice(0, 3)) && @parser_hash.keys.include?(param.slice(3, 6)) ? param : nil
      else
        nil
    end
  end
end
