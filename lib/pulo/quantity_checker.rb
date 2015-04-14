module Pulo

  module Quantity_Checker
    def quantity_check(*args)
      args.each do |arg|
        unless arg[0].class==arg[1] or arg[0].nil?
          raise ("Wrong argument type expecting a #{arg[1].name}")
        end
      end
    end
  end

end