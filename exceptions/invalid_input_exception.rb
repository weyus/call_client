class InvalidInputException < ::StandardError
  def initialize(op1, op2, type)
    @op1 = op1
    @op2 = op2
    @type = type
  end

  def message
    "One or both of the operands #{@op1} and #{@op2} are not #{@type}s"
  end
end