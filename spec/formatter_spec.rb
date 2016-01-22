require_relative '../src/formatter'

RSpec.describe ('Formatter') do

  it '#format_currency' do
    hash = {
              type: 'currency',
              data: { "ABC" => {
                      to_code: 'BBB',
                      from_code: 'CCC',
                      amount: 55.44,
                      change_amount: 4
              }
            }
          }

    value = hash[:data]['ABC']
    result = "_#{value[:from_code]} 1 = #{value[:to_code]} #{value[:amount]} #{EMOJI[:CHART_WITH_UPWARDS_TREND]}_\n\n"

    response = Formatter.format(hash)

    expect(response).to eq(result)
  end

  it '#format_price' do
    hash = {
            type: 'price',
            data: {
                    "ABC" => {
                              name: 'BBB',
                              amount: 55.44,
                              change_amount: -4,
                              change_percent: -5
                    }
                  }
            }
    value = hash[:data]['ABC']
    result = "#{hash[:data].keys.first} *$#{value[:amount]}* #{EMOJI[:CHART_WITH_DOWNWARDS_TREND]} #{value[:change_amount]}, #{value[:change_percent]}, #{value[:name]}\n"

    response = Formatter.format(hash)

    expect(response).to eq(result)
  end

  context '#format_stat' do
    before (:all) do
      @hash = {
              type: 'stat',
              data: {
                      "ABC" => {
                              name: 'BBB',
                              amount: 55.44,
                              change_amount: 4,
                              change_percent: 5,
                              dividend: 9,
                              pe: 1.55,
                              volume: 5,
                              'news' =>[ {title: 'Testing', url: 'www.ggg.com', date:'55.1.2015'} ]
                              }
                      }
              }
      end

    it '#format_spec' do
      value = @hash[:data]['ABC']

      result = "#{EMOJI[:CHART_WITH_UPWARDS_TREND]}  *$#{value[:amount]}*  #{value[:change_amount]}  #{value[:change_percent]}\n"
      result << "[dividend]   *$#{value[:dividend]}*\n"
      result << "[pe ratio]   *$#{value[:pe]}*\n"
      result << "[volume]     *#{value[:volume]}*\n\n"

      response = Formatter.print_spec(value)

      expect(response).to eq(result)
    end

    it '#format_news' do
      value = @hash[:data]['ABC']['news']
      result = "[#{value[0][:title]}](#{value[0][:url]})\n#{value[0][:date]}\n\n"

      response = Formatter.print_news(value)

      expect(response).to eq(result)
    end

    it '#format_stat' do
      result = "#{@hash[:data]['ABC'][:name]} #{@hash[:data].keys.first.upcase}\n"
      response = Formatter.format(@hash)

      expect(response).to include(result)
    end
  end
end
