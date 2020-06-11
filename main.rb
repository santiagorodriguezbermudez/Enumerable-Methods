if block_given?
end
module Enumerable
  def my_each
    return to_enum unless block_given?  
    each do |elem|
      yield(elem)
    end
    self
  end

  def my_each_with_index
    if block_given?
      index = 0
      each do |elem|
        yield(elem, index)
        index += 1
      end
      self
    else
      to_enum
    end
  end

  def my_select
    if block_given?
      new_arr = []
      my_each { |el| new_arr.push(el) if yield(el) }
      new_arr
    else
      to_enum
    end
  end

  def my_all?(arg = nil)
    cond = true
    if block_given?
      my_each { |el| cond &&= yield(el) }
      cond
    elsif arg
      my_each { |el| cond &&= arg === el }
      cond
    else
      my_each { |el| cond &&= true === el }
      cond
    end
  end

  def my_none?(arg = nil)
    cond = true
    if block_given?
      my_each { |el| cond &&= yield(el) }
      !cond
    elsif arg
      my_each { |el| cond &&= arg === el }
      !cond
    else
      my_each { |el| cond &&= true === el }
      !cond
    end
  end

  def my_any?(arg = nil)
    cond = false
    if block_given?
      my_each { |el| cond ||= yield(el) }
      cond
    elsif arg
      my_each { |el| cond ||= arg === el }
      cond
    else
      my_each { |el| cond ||= true === el }
      cond
    end
  end

  def my_count(arg = nil)
    accumulator = 0
    if block_given?
      my_each { |el| accumulator += 1 if yield(el) }
      accumulator
    elsif arg
      my_each { |el| accumulator += 1 if arg == el }
      accumulator
    else
      length
    end
  end

  def my_map(*args)
    return to_enum unless block_given?

    new_arr = []
    my_each { |el| new_arr.push(args[0] ? args[0].call(el) : yield(el)) }
    new_arr
  end

  def my_inject(*args)
    if block_given?
      memo = args[0] || ((first.is_a? Numeric) ? 0 : first)
      my_each { |el| memo = yield(memo, el) }
      memo
    elsif args.length == 0
      raise(LocalJumpError.new, 'No block or argument given')
    else
      case args.length
      when 1
        if args[0].is_a? Symbol
          memo = ((first.is_a? Numeric) ? 0 : first)
          my_each { |el| memo = memo&.send(args[0], el) }
          memo
        end
      when 2
        memo = args[0]
        my_each { |el| memo = memo&.send(args[1], el) }
        memo
      end
    end
  end
end

def multiply_els(arr)
  arr.my_inject(1, :*)
end
