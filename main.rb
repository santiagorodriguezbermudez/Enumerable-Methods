if block_given?
else
end
module Enumerable
    def my_each
        if block_given?
            for elem in self
                yield(elem)
            end
            self
        else
            self.to_enum
        end
    end

    def my_each_with_index
        if block_given?
            index=0
            for elem in self
                yield(elem,index)
                index += 1
            end
            self
        else
            self.to_enum
        end
    end

    def my_select
        if block_given?
            new_arr = []
            self.my_each {|el| new_arr.push(el) if yield(el)}
            new_arr
        else
            self.to_enum
        end
    end

    def my_all?(arg = nil)
        cond = true
        if block_given?
            self.my_each{|el| cond = cond && yield(el)}
            cond
        elsif arg
            self.my_each{|el| cond = cond && arg===el}
            cond
        else
            self.my_each{|el| cond = cond && true === el}
            cond
        end
    end

    def my_none?(arg = nil)
        cond = true
        if block_given?
            self.my_each{|el| cond = cond && yield(el)}
            !cond
        elsif arg
            self.my_each{|el| cond = cond && arg===el}
            !cond
        else
            self.my_each{|el| cond = cond && true === el}
            !cond
        end
    end

    def my_any? (arg = nil)
        cond = false
        if block_given?
            self.my_each{|el| cond = cond || yield(el)}
            cond
        elsif arg
            self.my_each{|el| cond = cond || arg===el}
            cond
        else
            self.my_each{|el| cond = cond || true === el}
            cond
        end     
    end

    def my_count (arg = nil)
        accumulator = 0
        if block_given?
            self.my_each{|el| accumulator += 1 if yield(el)}
            accumulator
        elsif arg
            self.my_each{|el| accumulator += 1 if arg==el}
            accumulator
        else
            self.length
        end    
    end

    def my_map
        return self.to_enum unless block_given?
        new_arr = []
        self.my_each {|el| new_arr.push(yield(el))}
        new_arr
    end

    def my_inject(*args)
        if block_given?
            memo = args[0] || ((self.first.is_a? Numeric) ? 0 : self.first)
            self.my_each{|el| memo = yield(memo, el)}
            memo
        else
            case args.length
            when 1
                if args[0].is_a? Symbol
                    memo = ((self.first.is_a? Numeric) ? 0 : self.first)
                    self.my_each {|el| memo = memo&.send(args[0], el)}
                    memo
                end
            when 2
                memo = args[0]
                self.my_each {|el| memo = memo&.send(args[1], el)}
                memo
            end
        end
       
    end
end

#def my_inject(*args)
#my_inject() {}

# Sum some numbers
p (5..10).my_inject(:+)                             #=> 45
# Same using a block and inject
p (5..10).my_inject { |sum, n| sum + n }            #=> 45
# Multiply some numbers
p (5..10).my_inject(1, :*)                          #=> 151200
# Same using a block
p (5..10).my_inject(1) { |product, n| product * n } #=> 151200
# find the longest word
longest = %w{ cat sheep bear }.my_inject do |memo, word|
   memo.length > word.length ? memo : word
end
p longest                                        #=> "sheep"

