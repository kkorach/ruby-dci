require 'dci'

class Account
  attr_reader :balance

  def initialize(balance)
    @balance = balance
  end
end

class MoneyTransfer < DCI::Context

  role :Destination do
    def deposit(amount)
      @balance += amount
    end
  end

  role :Source do
    def withdraw(amount)
      @balance -= amount
    end

    def transfer(amount)
      puts "Source balance is: #{Source.balance}"
      puts "Destination balance is: #{Destination.balance}"

      Source.withdraw(amount)
      Destination.deposit(amount)

      puts "Source balance is now: #{Source.balance}"
      puts "Destination balance is now: #{Destination.balance}"
    end
  end

  entry :transfer do |amount|
    Source.transfer(amount)
  end

  def initialize(src, dest)
    self.Source = src
    self.Destination = dest
  end

end

# role classes are not named in the context
puts "* MoneyTransfer constants:", MoneyTransfer.constants, ""

# role variables are accessible (though only roles should access...)
puts "* MoneyTransfer public methods:", MoneyTransfer.public_instance_methods(false), ""
puts "* MoneyTransfer protected methods:", MoneyTransfer.protected_instance_methods(false), ""

context = MoneyTransfer.new(Account.new(1000), Account.new(0))
context.transfer(245)

