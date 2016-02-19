require_relative '../src/api_helper'
require 'csv'
require 'byebug'

RSpec.describe 'ApiHelper' do
  subject do
    class A
      include ApiHelper
    end

    A.new
  end

  before(:each) do
    stub_const('CHART_PATH', 'url/')
    stub_const('PRICE_FLAGS', '110')
    stub_const('STAT_FLAGS', '001')
    stub_const('NEWS_PATH', 'news/')
    stub_const('CHART_IMAGE_PATH', 'tmp/test_image.jpg')
    # TODO: refactor this
    allow(OpenURI).to receive(:open).with(CHART_PATH, 'wb').and_return('chart')
  end

  it '#get_chart'

  it '#get_preview' do
    params = 'coffee'

    response = subject.get_preview(params)

    expect(response).to eql("#{CHART_PATH}s=#{params}")
  end

  it '#get_price' do
    # TODO: refactor
    allow_any_instance_of(Kernel).to receive_message_chain(:open, :read).and_return('SGX,S68.SI,15,x,+1 - +3')
    params = 'coffee'
    result = { 'S68.SI' => { name: 'SGX', amount: '15', change_amount: '+1', change_percent: '+3' } }

    response = subject.get_price(params)

    expect(response).to eql(result)
  end

  it '#get_stat' do
    result = { 'apple' => { 'orange' => 'water', 'pear' => 'soda' } }
    breakdown_data = { 'apple' => { 'orange' => 'water' } }
    news_data = { 'apple' => { 'pear' => 'soda' } }
    allow_any_instance_of(ApiHelper).to receive(:get_breakdown).with('apple').and_return(breakdown_data)
    allow_any_instance_of(ApiHelper).to receive(:get_news).with('apple').and_return(news_data)

    response = subject.get_stat('apple')

    expect(response).to eql(result)
  end

  it '#get_breakdown' do
    result = { 'S68.SI' => { name: 'SGX',
                             amount: '15',
                             change_amount: '-4',
                             change_percent: '+5',
                             volume: '999',
                             dividend: '456',
                             pe: '123' } }
    data = 'SGX,S68.SI,15,123,456,x,-4 - +5,x,999'

    # TODO: refactor
    allow_any_instance_of(Kernel).to receive_message_chain(:open, :read).and_return(data)

    response = subject.get_breakdown('S68.SI')

    expect(response).to eql(result)
  end

  it '#get_news' do
    params = 'coffee'
    result = { 'coffee' => { news: [{ title: 'Mr', url: 'link', date: '06 Oct 2015 03:31:39 GMT' }] } }
    item = '<item>
              <title>Mr</title>
              <link>url/*link</link>
              <pubDate>Tue, 06 Oct 2015 03:31:39 GMT</pubDate>
             </item>'
    # TODO: refactor
    allow_any_instance_of(Kernel).to receive_message_chain(:open, :read).and_return(item)

    response = subject.get_news(params)

    expect(response).to eql(result)
  end
end
