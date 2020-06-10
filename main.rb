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

  def my_each_with_index
    return to_enum unless block_given?
    i = 0
    while i < length
      yield(self[i], i)
      i += 1
    end
    self
  end

  def my_select
    return to_enum unless block_given?
    new_array = Array.new
    my_each {|el| new_array.push(el) if yield(el)}
    new_array
  end
end

# Testing comparison
# each test
# a = %w[a b c]
# a.each { |x| p x, ' -- ' }
# a.my_each { |x| p x, ' -- ' }

# each_with_index test
# hash = Hash.new
# my_hash = Hash.new
# %w(cat dog wombat).each_with_index { |item, index|
#   hash[item] = index
# }
# %w(cat dog wombat).my_each_with_index { |item, index|
#   my_hash["my " + item] = index
# }
# p hash
# p my_hash

# select test
# p [1,2,3,4,5].select { |num|  num.even?  }   
# p [1,2,3,4,5].my_select { |num|  num.even?  }   