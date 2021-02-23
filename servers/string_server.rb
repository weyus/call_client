class StringServer
  def calculate(op1, op2)
    puts "Call #{self.class.name}..." if $0 == 'irb'

    first_method = @operations[0]

    #op1.dup is to ensure that op1 doesn't get modified in place from another call
    result = op1.dup.send(first_method, op2)
    @operations[1..-1].each {|method| result = result.send(method)}
    result
  end

  private

  def initialize(operations)
    @operations = operations
  end
end

class ConcatenateUpcaseServer < StringServer
  private

  def initialize
    super([:concat, :upcase])  #Could use :+ instead of concat here
  end
end

class ConcatenateUpcaseReverseServer < StringServer
  private

  def initialize
    super([:concat, :upcase, :reverse])  #Could use :+ instead of concat here
  end
end