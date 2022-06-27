require_relative './user'
require_relative './product'

class VendingMachine
  attr_reader :products, :ordered_product, :entered_money, :money_change, :income

  def initialize(products = [])
    @products = products
    @ordered_product = nil
    @entered_money = 0
    @money_change = 0
    @income = 0
  end

  def make_an_order(money, code, user)
    product = find_vm_product_by_code(code)

    raise "Can't find product with provided code" if product.nil?
    raise "Not enough coins!" if product.price > money
    raise "There is already some order in progress.\nPlease, finish or cancel current order to make a new one." unless ordered_product.nil?

    user.money -= money

    @ordered_product = product
    @entered_money = money
    @money_change = money - product.price
    @income += product.price
  end

  def return_product_for_user(user)
    raise "There is no ordered product" if ordered_product.nil?

    products.delete(ordered_product)
    user.products << ordered_product
    user.money += money_change
  end

  def cancel_order(user)
    raise "There is no order to cancel" if ordered_product.nil?

    user.money += entered_money
    restock(ordered_product)
    @ordered_product = nil
  end

  def restock(*products)
    @products.concat(products)
  end

  def stock(*products)
    @products = products
  end

  private

  def find_vm_product_by_code(code)
    products.find { |product| product.code == code }
  end
end
