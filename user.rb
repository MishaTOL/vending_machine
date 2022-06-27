class User
  attr_reader :products
  attr_accessor :money

  def initialize(money, products = [])
    @money = money
    @products = products
  end
end
