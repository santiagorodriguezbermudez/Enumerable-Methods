module Enumerable
  def my_each
    return to_enum unless block_given?

    for elem in self
      yield(elem)
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    index = 0
    for elem in self
      yield(elem, index)
      index += 1
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    new_arr = []
    my_each { |el| new_arr.push(el) if yield(el) }
    new_arr
  end

  def my_all?(arg = nil)
    cond = true
    if block_given?
      my_each { |el| cond &&= yield(el) }
    elsif arg
      my_each { |el| cond &&= arg === el }
    else
      my_each { |el| cond &&= true === el }
    end
    cond
  end

  def my_none?(arg = nil)
    cond = true
    if block_given?
      my_each { |el| cond &&= yield(el) }
    elsif arg
      my_each { |el| cond &&= arg === el }
    else
      my_each { |el| cond &&= true === el }
    end
    !cond
  end

  def my_any?(arg = nil)
    cond = false
    if block_given?
      my_each { |el| cond ||= yield(el) }
    elsif arg
      my_each { |el| cond ||= arg === el }
    else
      my_each { |el| cond ||= true === el }
    end
    cond
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
    self_copy = to_a
    if block_given?
      memo = args[0] || self_copy.shift
      self_copy.my_each { |el| memo = yield(memo, el) }
    elsif args.empty?
      raise(LocalJumpError.new, 'No block or argument given')
    elsif args.length == 1
      memo = self_copy.shift
      self_copy.my_each { |el| memo = memo.send(args[0], el) }
    else
      memo = self_copy.shift
      self_copy.my_each { |el| memo = memo.send(args[1], el) }
    end
    memo
  end
end

def multiply_els(arr)
  arr.my_inject(1, :*)
end
