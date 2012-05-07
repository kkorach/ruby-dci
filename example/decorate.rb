require 'dci_decorate'

class Account
  attr_accessor :balance

  def initialize(balance)
    @balance = balance
  end
end

class MoneyTransfer < DCI::Context

  class Destination < DCI::Role(Account)
    def deposit(amount)
      self.balance += amount
    end
  end

  role :destination, Destination

  role :source, Account do
    def withdraw(amount)
      self.balance -= amount
    end

    def transfer(amount)
      puts "Source balance is: #{context.source.balance}"
      puts "Destination balance is: #{context.destination.balance}"

      context.source.withdraw(amount)
      context.destination.deposit(amount)

      puts "Source balance is now: #{context.source.balance}"
      puts "Destination balance is now: #{context.destination.balance}"
    end
  end

  entry :transfer do |amount|
    @source.transfer(amount)
  end

  def initialize(src, dest)
    self.source = src
    self.destination = dest
  end
end

# role classes are named in the context
puts "* MoneyTransfer constants:", MoneyTransfer.constants, ""

# role variables are readable (though only roles should access...)
puts "* MoneyTransfer public methods:", MoneyTransfer.public_instance_methods(false), ""
puts "* MoneyTransfer protected methods:", MoneyTransfer.protected_instance_methods(false), ""

context = MoneyTransfer.new(Account.new(1000), Account.new(0))
context.transfer(245)
