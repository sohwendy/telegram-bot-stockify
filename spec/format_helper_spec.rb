require_relative '../src/format_helper'
require 'byebug'

RSpec.describe ('FormatHelper') do

  subject {
    class B
      include FormatHelper
    end

    B.new
  }

  it { is_expected.to respond_to(:format_currency)}
  it { is_expected.to respond_to(:format_stat)}
  it { is_expected.to respond_to(:format_list)}
  it { is_expected.to respond_to(:format_price)}
  it { is_expected.to respond_to(:print_news)}
  it { is_expected.to respond_to(:print_spec)}

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
    result = "<i>#{value[:from_code]} 1 = #{value[:to_code]} #{value[:amount]} \xF0\x9F\x93\x88</i>\n\n"

    response = subject.format(hash)

    expect(response).to eq(result)
  end

  it '#format_list' do
    hash = { type: 'list', data: { a: {name: 'apple', tag: 'fruits'}, b: {name: 'banana', tag: 'fruits'}}}
    result = "a    <b>apple</b>    fruits\nb    <b>banana</b>    fruits\n"

    response = subject.format(hash)

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
    result = "#{hash[:data].keys.first} <b>$#{value[:amount]}</b> \xF0\x9F\x93\x89 #{value[:change_amount]}, #{value[:change_percent]}, #{value[:name]}\n"

    response = subject.format(hash)

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

    it '#print_spec' do
      value = @hash[:data]['ABC']

      result = "\xF0\x9F\x93\x88  <b>$#{value[:amount]}</b>  #{value[:change_amount]}  #{value[:change_percent]}\n"
      result << "[dividend]   <b>$#{value[:dividend]}</b>\n"
      result << "[pe ratio]   <b>$#{value[:pe]}</b>\n"
      result << "[volume]     <b>#{value[:volume]}</b>\n\n"

      response = subject.print_spec(value)

      expect(response).to eq(result)
    end

    it '#print_news' do
      value = @hash[:data]['ABC']['news']
      result = "<a href='#{value[0][:url]}'>#{value[0][:title]}</a>\n#{value[0][:date]}\n\n"

      response = subject.print_news(value)

      expect(response).to eq(result)
    end

    it '#format_stat' do
      result = "#{@hash[:data]['ABC'][:name]} #{@hash[:data].keys.first.upcase}\n"
      response = subject.format(@hash)

      expect(response).to include(result)
    end
  end
end
