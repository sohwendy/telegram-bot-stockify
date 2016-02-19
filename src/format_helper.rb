require_relative 'constants/constants'

module FormatHelper
  def format(data)
    if respond_to?("format_#{data[:type]}")
      send("format_#{data[:type]}", data[:data])
    end
  end

  def format_list(data)
    result = ''
    data.each_pair { |key, value|
      result << "#{key}    "
      result << "<b>#{value[:name]}</b>    "
      result << "#{value[:tag]}\n"
    }
    result
  end

  def format_currency(data)
    result = ''
    data.each_value { |value|
      result << "<i>#{value[:from_code]} 1 = "
      result << "#{value[:to_code]} #{value[:amount]} "
      result << "#{trend(value[:change_amount].to_f)}</i>\n\n"
    }
    result
  end

  def format_price(data)
    result = ''
    data.each_pair { |key, value|
      result << "#{key} "
      result << "<b>$#{value[:amount]}</b> "
      result << "#{trend(value[:change_amount].to_f)} "
      result << "#{value[:change_amount]}, "
      result << "#{value[:change_percent]}, "
      result << "#{value[:name]}\n"
    }
    result
  end

  def format_stat(data)
    result = ''
    data.each_pair { |key, value|
      result << "#{value[:name]} #{key.upcase}\n"
      result << print_spec(value)
      result << print_news(value[:news])
    }
    result
  end

  # TODO: refactor this, inconsistent with other method
  def print_spec(data)
    result = ''
    result << "#{trend(data[:change_amount].to_f)}"
    result << "  <b>$#{data[:amount]}</b>  "
    result << "#{data[:change_amount]}  "
    result << "#{data[:change_percent]}\n"
    result << "[dividend]   <b>$#{data[:dividend]}</b>\n"
    result << "[pe ratio]   <b>$#{data[:pe]}</b>\n"
    result << "[volume]     <b>#{data[:volume]}</b>\n\n"
    result
  end

  # TODO: refactor this, inconsistent with other method
  def print_news(data)
    result = ''
    unless data.nil?
      data.each { |hash|
        result << "<a href='#{hash[:url]}'>#{hash[:title]}</a>\n"
        result << "#{hash[:date]}\n\n"
      }
    end
    result
  end

  def trend(value)
    if value > 0
      Emoji::CHART_WITH_UPWARDS_TREND
    elsif value < 0
      Emoji::CHART_WITH_DOWNWARDS_TREND
    else
      Emoji::HEAVY_MINUS_SIGN
    end
  end
end
