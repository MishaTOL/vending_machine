require_relative '../vending_machine.rb'

RSpec.describe VendingMachine do
  context 'Vending Machine check' do
    let(:product1) { Product.new(50, 1) }
    let(:product2) { Product.new(20, 2) }
    let(:product3) { Product.new(50, 3) }
    let(:product4) { Product.new(20, 4) }
    let(:vending_machine) { VendingMachine.new([product1, product2]) }
    let(:user) { User.new(500) }

    it 'creates vending machine with provided products' do
      expect(vending_machine.products.count).to eq 2
    end

    it 'restocks vending machine' do
      vending_machine.restock(product3, product4)
      expect(vending_machine.products.count).to eq 4
    end

    it 'stocks vending machine' do
      vending_machine.stock(product3, product4)
      expect(vending_machine.products.count).to eq 2
    end

    context '#make_an_order' do
      it 'raises an error if entered money less than product price' do
        expect { vending_machine.make_an_order(10, 1, user) }.to raise_error("Not enough coins!")
      end

      it 'raises an error if provided code is wrong' do
        expect { vending_machine.make_an_order(50, 12312, user) }.to raise_error("Can't find product with provided code")
      end

      it 'raises an error when there is already order in progress' do
        vm = vending_machine
        vm.make_an_order(50, 1, user)

        expect { vm.make_an_order(50, 1, user) }.to raise_error("There is already some order in progress.\nPlease, finish or cancel current order to make a new one.")
      end

      it 'orders a product' do
        vending_machine.make_an_order(100, 1, user)

        expect(vending_machine.income).to eq 50
        expect(vending_machine.money_change).to eq 50
        expect(vending_machine.ordered_product).to eq product1
        expect(user.money).to eq 400
      end
    end

    context '#return_product_for_user' do
      it 'raises an error if product has not been ordered' do
        expect { vending_machine.return_product_for_user(user) }.to raise_error("There is no ordered product")
      end

      context 'vending maching have ordered product' do
        before do
          vending_machine.make_an_order(100, 1, user)
          vending_machine.return_product_for_user(user)
        end

        it 'gives product to user' do
          expect(user.products).to include(product1)
        end

        it 'returns money change to user' do
          expect(user.money).to eq 450
        end
      end
    end

    context '#cancel_order' do
      it 'raises an error if product has not been ordered' do
        expect { vending_machine.cancel_order(user) }.to raise_error("There is no order to cancel")
      end

      context 'vending machine have order in progress' do
        before do
          vending_machine.make_an_order(100, 1, user)
          vending_machine.cancel_order(user)
        end

        it 'returns money to user' do
          expect(user.money).to eq 500
        end

        it 'restock ordered product' do
          expect(vending_machine.products).to include product1
        end

        it 'removes ordered product' do
          expect(vending_machine.ordered_product).to eq nil
        end
      end
    end
  end
end
