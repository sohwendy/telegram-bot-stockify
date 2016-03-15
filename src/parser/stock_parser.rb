class StockParser
  def initialize(parameters)
    @hash = {}
    CSV.foreach(parameters, headers: true) do |row|
      @hash.merge!(row[0] => { name: row[1], tag: row[3] })
    end
  end

  def get_from_symbol(name)
    name = '...' unless name
    @hash.select { |key, _| key.include?(name.upcase) }
  end
end
