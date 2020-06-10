module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    while i < length
      yield(self[i])
      i += 1
    end
    self
  end
end

# Testing comparison
a = %w[a b c]
a.each { |x| print x, ' -- ' }
a.my_each { |x| print x, ' -- ' }
