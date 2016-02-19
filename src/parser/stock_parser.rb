class StockParser
  def initialize(parameters)
    @hash = {}
    CSV.foreach(parameters, headers: true) do |row|
      @hash.merge!(row[0] => { name: row[1], tag: row[3] })
    end
  end

  def get_from_symbol(name)
    name = '...' unless name
    @hash.select { |key, _| key.downcase.include?(name.downcase) }
  end

  def get_from_tags(tag)
    tag = 'poor' unless tag
    @hash.select { |_, value| value[:tag].downcase.include?(tag.downcase) }
  end

  def get_list(name)
    name = '' unless name
    get_from_tags(name)
  end
end
