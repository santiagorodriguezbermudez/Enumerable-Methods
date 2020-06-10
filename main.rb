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

  def my_all? (arg = nil)
    if block_given?
        my_select{|el| yield(el)}.length == self.length
    else
        if arg
            my_select{|el| arg === el}.length == self.length
        else
            my_select{|el| true === el}.length == self.length
        end
    end
  end

  def my_any? (arg = nil)
    if block_given?
        my_select{|el| yield(el)}.length > 0
    else
        if arg
            my_select{|el| arg === el}.length > 0
        else
            my_select{|el| true === el}.length > 0
        end
    end
  end

  def my_count (arg = nil)
    if block_given?
        my_select{|el| yield(el)}.length
    else
        if arg
            my_select{|el| arg === el}.length
        else
            length
        end
    end
  end

  def my_map
    return to_enum unless block_given?
    new_array = Array.new
    my_each {|el| new_array.push(yield(el))}
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

# all? test
# p "all results:"
# p %w[ant bear cat].all? { |word| word.length >= 3 } #=> true
# p %w[ant bear cat].all? { |word| word.length >= 4 } #=> false
# p %w[ant bear cat].all?(/t/)                        #=> false
# p [1, 2i, 3.14].all?(Numeric)                       #=> true
# p [nil, true, 99].all?                              #=> false
# p [].all?                                           #=> true
# p "My all results:"
# p %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
# p %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
# p %w[ant bear cat].my_all?(/t/)                        #=> false
# p [1, 2i, 3.14].my_all?(Numeric)                       #=> true
# p [nil, true, 99].my_all?                              #=> false
# p [].my_all?                                           #=> true

# any? test
# p "any results:"
# p %w[ant bear cat].any? { |word| word.length >= 3 } #=> true
# p %w[ant bear cat].any? { |word| word.length >= 4 } #=> true
# p %w[ant bear cat].any?(/d/)                        #=> false
# p [nil, true, 99].any?(Integer)                     #=> true
# p [nil, true, 99].any?                              #=> true
# p [].any?                                           #=> false
# p "my_any results:"
# p %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
# p %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
# p %w[ant bear cat].my_any?(/d/)                        #=> false
# p [nil, true, 99].my_any?(Integer)                     #=> true
# p [nil, true, 99].my_any?                              #=> true
# p [].my_any?                                           #=> false

# count test
# p "count results:"
# p ary = [1, 2, 4, 2]
# p ary.count               #=> 4
# p ary.count(2)            #=> 2
# p ary.count{ |x| x%2==0 } #=> 3
# p "my_count results:"
# p ary.my_count               #=> 4
# p ary.my_count(2)            #=> 2
# p ary.my_count{ |x| x%2==0 } #=> 3

# map test
p "map results:"
p a = [ "a", "b", "c", "d" ]
p a.map {|x| x + "!"}           #=> ["a!", "b!", "c!", "d!"]
p a.map.with_index {|x, i| x * i}   #=> ["", "b", "cc", "ddd"]
p a                                 #=> ["a", "b", "c", "d"]
p "my_map results:"
p a = [ "a", "b", "c", "d" ]
p a.my_map {|x| x + "!"}           #=> ["a!", "b!", "c!", "d!"]
p a.my_map.with_index {|x, i| x * i}   #=> ["", "b", "cc", "ddd"]
p a                                 #=> ["a", "b", "c", "d"]