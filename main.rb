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

    def my_map(*args)
        return self.to_enum unless block_given?
        new_arr = []
        self.my_each {|el| new_arr.push(args[0]? args[0].call(el) : yield(el))}
        new_arr
    end

    def my_inject(*args)
        if block_given?
            memo = args[0] || ((self.first.is_a? Numeric) ? 0 : self.first)
            self.my_each{|el| memo = yield(memo, el)}
            memo
        elsif args.length == 0
            raise(LocalJumpError.new, "No block or argument given")
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

def multiply_els (arr)
    arr.my_inject(1, :*)
end

p multiply_els([2,4,5])

# Testing my_map against map with a given proc
prov_var = Proc.new {|n| puts n*2}
p [1,2,3].my_map(&prov_var)
p [1,2,3].map(&prov_var)

