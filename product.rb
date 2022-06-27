class Product
  attr_reader :price, :code

  def initialize(price, code)
    @price = price
    @code = code
  end
end
