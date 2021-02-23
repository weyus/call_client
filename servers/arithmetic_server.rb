class ArithmeticServer
  def calculate(op1, op2)
    puts "Call #{self.class.name}..." if $0 == 'irb'
    op1.send(@operation, op2)
  end

  private

  def initialize(operation)
    @operation = operation
  end
end

class SumServer < ArithmeticServer
  private

  def initialize
    super("+")
  end
end

class DifferenceServer < ArithmeticServer
  private

  def initialize
    super("-")
  end
end
