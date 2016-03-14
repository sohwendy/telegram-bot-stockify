require_relative '../src/format_helper'
require 'byebug'

RSpec.describe 'FormatHelper' do
  subject do
    class B
      include FormatHelper
    end

    B.new
  end

  it { is_expected.to respond_to(:format_stat) }
  it { is_expected.to respond_to(:format_price) }
  it '#format_price' do
    hash = { 'ABC' => { name: 'BBB',
                        amount: 55.44,
                        change_amount: -4,
                        change_percent: -5
                      }
           }
    value = hash['ABC']
    result = "$#{value[:amount]} #{value[:change_amount]}  #{Emoji::CHART_WITH_DOWNWARDS_TREND}"\
             " #{hash.keys.first} #{value[:name]}\n"

    response = subject.format_price(hash)

    expect(response).to eq(result)
  end

  context '#format_stat' do
    before :all do
      @hash = { 'ABC' => { name: 'BBB',
                           amount: 55.44,
                           change_amount: 4,
                           change_percent: 5,
                           dividend: 9,
                           pe: 1.55,
                           volume: 5,
                           'news' => [{ title: 'Testing',
                                        url: 'www.ggg.com',
                                        date: '55.1.2015' }]
                         }
              }
    end

    it '#format_stat' do
      result = "#{@hash['ABC'][:name]} #{@hash.keys.first.upcase}\n"
      response = subject.format_stat(@hash)

      expect(response).to include(result)
    end
  end
end
