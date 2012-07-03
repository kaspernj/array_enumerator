#This class is ment as an enumerator but with a cache that enables it to emulate array-functionality (first, empty and so on). If elements goes out of memory, then the array becomes corrupted and methods like 'first' and 'slice' will no longer work (raise errors).
class Array_enumerator
  #Takes an enumerator to work with as argument.
  def initialize(enum)
    #The enumerator being used.
    @enum = enum
    
    #Used to calculate length without depending corruption.
    @length_cache = 0
    
    #If the virtual array has become corrupted because of forgotten elements (by calling each and enumerating through elements).
    @array_corrupted = false
    
    #To allow the object to be thread-safe.
    @mutex = Mutex.new
  end
  
  #Cache the first elements (if not cached already) and returns it.
  def first
    check_corrupted
    cache_ele if !@eles or @eles.empty?
    return @eles.first
  end
  
  #Returns true if the array is empty.
  def empty?
    if @empty == nil
      cache_ele if !@eles
      
      if @length_cache > 0
        @empty = false
      else
        @empty = true
      end
    end
    
    return @empty
  end
  
  #Returns each element and releases them from cache.
  def each(&block)
    if block
      to_enum.each(&block)
      return nil
    else
      return to_enum
    end
  end
  
  #Returns a enumerator that can yield the all the lements (both cached and future un-cached ones).
  def to_enum
    check_corrupted
    @array_corrupted = true
    
    return Enumerator.new do |yielder|
      if @eles
        while ele = @eles.shift
          yielder << ele
        end
      end
      
      yield_rest do |ele|
        yielder << ele
      end
    end
  end
  
  #Returns the counted length. Can only be called after the end of the enumerator has been reached.
  def length
    raise "Cant call length before the end has been reached." if !@end
    return @length_cache
  end
  
  #Giving slice negaive arguments will force it to cache all elements and crush the memory for big results.
  def slice(*args)
    check_corrupted
    
    if args[0].is_a?(Range) and !args[1]
      need_eles = args[0].begin + args[0].end
    elsif args[0] and !args[1]
      need_eles = args[0]
    elsif args[0] and args[1] and args[0] > 0 and args[1] > 0
      need_eles = args[0] + args[1]
    elsif args[0] < 0 or args[1] < 0
      raise "Slice cant take negative arguments."
    else
      raise "Dont now what to do with args: '#{args}'."
    end
    
    @eles = [] if !@eles
    cache_eles = need_eles - @eles.length if need_eles
    cache_ele(cache_eles) if need_eles and cache_eles > 0
    return @eles.slice(*args)
  end
  
  #Caches necessary needed elements and then returns the result as on a normal array.
  def shift(*args)
    check_corrupted
    
    if args[0]
      amount = args[0]
    else
      amount = 1
    end
    
    @eles = [] if !@eles
    cache_ele(amount - @eles.length) if !@eles or @eles.length < amount
    res = @eles.shift(*args)
    
    #Since we are removing an element, the length should go down with the amount of elements captured.
    if args[0]
      @length_cache -= res.length
    else
      @length_cache -= 1
    end
    
    return res
  end
  
  #Returns a normal array with all elements. Can also raise corrupted error if elements have been thrown out.
  def to_a
    check_corrupted
    cache_all
    return @eles
  end
  
  alias to_ary to_a
  
  private
  
  #Raises error because elements have been forgotten to spare memory.
  def check_corrupted
    raise "Too late to call. Corrupted." if @array_corrupted
  end
  
  #Yields the rest of the elements to the given block.
  def yield_rest
    @array_corrupted = true
    
    begin
      @mutex.synchronize do
        while ele = @enum.next
          @length_cache += 1
          yield(ele)
        end
      end
    rescue StopIteration
      @end = true
    end
  end
  
  #Caches a given amount of elements.
  def cache_ele(amount = 1)
    @eles = [] if !@cache
    
    begin
      @mutex.synchronize do
        while @eles.length <= amount
          @eles << @enum.next
          @length_cache += 1
        end
      end
    rescue StopIteration
      @end = true
    end
  end
  
  #Forces the rest of the elements to be cached.
  def cache_all
    @eles = [] if !@eles
    
    begin
      @mutex.synchronize do
        while ele = @enum.next
          @length_cache += 1
          @eles << ele
        end
      end
    rescue StopIteration
      @end = true
    end
  end
end