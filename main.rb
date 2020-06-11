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
end
