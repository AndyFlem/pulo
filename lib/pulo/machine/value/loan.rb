class Loan
  attr_reader :rate, :term, :principal
  attr_reader :payment
  def initialize rate: nil, term: nil, principal: nil
    @rate=rate
    @term=term
    @principal=principal

    @payment=(rate*principal)/(1-(1+rate)**-term)
  end
end