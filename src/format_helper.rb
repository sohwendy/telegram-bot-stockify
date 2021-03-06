require_relative 'constants'

module FormatHelper
  def format_price(data)
    result = ''
    data.each_pair do |key, value|
      result << "$#{value[:amount]} "
      result << "#{value[:change_amount]}  "
      result << "#{Emoji.trend(value[:change_amount].to_f)} "
      result << "#{key} "
      # result << "#{value[:change_percent]} "
      result << "#{value[:name]}\n"
    end
    result
  end

  def format_stat(data)
    result = ''
    data.each_pair do |key, value|
      result << "#{value[:name]} #{key.upcase}\n"
      result << print_spec(value)
      result << print_news(value[:news])
    end
    result
  end

  private

  # TODO: refactor this, inconsistent with other method
  def print_spec(data)
    result = ''
    result << "#{Emoji.trend(data[:change_amount].to_f)}"
    result << "  $#{data[:amount]}  #{data[:change_amount]}  #{data[:change_percent]}\n"
    result << "[dividend]   $#{data[:dividend]}\n"
    result << "[pe ratio]   $#{data[:pe]}\n"
    result << "[volume]     #{data[:volume]}\n\n"
    result
  end

  # TODO: refactor this, inconsistent with other method
  def print_news(data)
    result = ''
    unless data.nil?
      data.each do |hash|
        result << "<a href='#{hash[:url]}'>#{hash[:title]}</a>\n"
        result << "#{hash[:date]}\n\n"
      end
    end
    result
  end
end
