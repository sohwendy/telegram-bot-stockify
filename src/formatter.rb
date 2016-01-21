require_relative 'constants/emoji_constants'

module Formatter

  def self.format(data)
    if self.respond_to?("format_#{data[:type]}")
      self.send("format_#{data[:type]}", data[:data])
    end
  end

  def self.format_currency(data)
    result = ''
    data.each { |_, value|
      result << "_#{value[:from_code]} 1 = #{value[:to_code]} #{value[:amount]} #{trend(value[:change_amount].to_f)}_\n\n"
    }
    result
  end

  def self.format_price(data)
    result = ''
    data.each { |key, value|
      result << "#{key} *$#{value[:amount]}* #{trend(value[:change_amount].to_f)} #{value[:change_amount]}, #{value[:change_percent]}, #{value[:name]}\n"
    }
    result
  end

  def self.format_stat(data)
    result = ''
    data.each { |key, value|
      p value[:name]
      result << "#{value[:name]} #{key.upcase}\n"
      result << format_spec(value)
      result << format_news(value[:news])
    }
    result
  end

  def self.format_spec(data)
    result = ''
    result << "#{trend(data[:change_amount].to_f)}  *$#{data[:amount]}*  #{data[:change_amount]}  #{data[:change_percent]}\n"
    result << "[dividend]   *$#{data[:dividend]}*\n"
    result << "[pe ratio]   *$#{data[:pe]}*\n"
    result << "[volume]     *#{data[:volume]}*\n\n"
    result
  end

  def self.format_news(data)
    result = ''
    data.each { |hash|
      result << "[#{hash[:title]}](#{hash[:url]})\n"
      result << "#{hash[:date]}\n\n"
    }
    result
  end

  def self.trend(value)
    if value > 0
      EMOJI[:CHART_WITH_UPWARDS_TREND]
    elsif value < 0
      EMOJI[:CHART_WITH_DOWNWARDS_TREND]
    else
      EMOJI[:HEAVY_MINUS_SIGN]
    end
  end
end
