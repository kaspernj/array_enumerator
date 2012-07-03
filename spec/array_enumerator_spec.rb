require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ArrayEnumerator" do
  it "shift" do
    cont = %w[a b c d e].to_enum
    ae = Array_enumerator.new(cont)
    
    res = ae.shift
    raise "Expected 'a' but got: '#{res}'." if res != "a"
    
    arr = ae.to_a
    exp = %w[b c d e]
    raise "Expected array to be '#{exp}' but got: '#{arr}'." if arr != exp
  end
  
  it "each" do
    arr = %w[a b c]
    cont = arr.to_enum
    ae = Array_enumerator.new(cont)
    
    count = 0
    ae.each do |ele|
      raise "Expected #{arr[count]} but got: #{ele}" if ele != arr[count]
      count += 1
    end
    
    raise "Expected 3 elements to yield through but got: #{count}" if count != 3
    
    arr = %w[a b c]
    cont = arr.to_enum
    ae = Array_enumerator.new(cont)
    
    res = ae.empty?
    raise "Expected empty to be false but got: '#{res}'." if res != false
    
    count = 0
    ae.each do |ele|
      raise "Expected #{arr[count]} but got: #{ele}" if ele != arr[count]
      count += 1
    end
    
    raise "Expected 3 elements to yield through but got: #{count}" if count != 3
    
    begin
      ae.to_a
      raise "Should have raised exception but didnt."
    rescue
      #ignore.
    end
    
    begin
      ae.first
      raise "Should have raised exception but didnt."
    rescue
      #ignore.
    end
    
    begin
      ae.each do |ele|
        raise "Should get here?"
      end
      
      raise "Should get here?"
    rescue
      #ignore.
    end
  end
  
  it "empty" do
    cont = %w[a b c].to_enum
    ae = Array_enumerator.new(cont)
    
    res = ae.empty?
    raise "Expected empty to be false but got: '#{res}'." if res != false
    
    first = ae.first
    raise "Expected first to be 'a' but it wasnt: '#{first}'." if first != "a"
  end
  
  it "length" do
    cont = %w[a b c d e].to_enum
    ae = Array_enumerator.new(cont)
    
    begin
      ae.length
      raise "Should have failed but didnt."
    rescue
      #ignore.
    end
    
    ae.each do |ele|
      #ignore.
    end
    
    res = ae.length
    raise "Expected length to be 5 but it wasnt: '#{res}'." if res != 5
  end
  
  it "slice" do
    arr = %w[a b c d e f g h i j k l m n]
    cont = arr.to_enum
    ae = Array_enumerator.new(cont)
    
    runs = [
      [6],
      [1, 2],
      [1..3]
    ]
    
    fails = [
      [-2, 2],
      [2, -2]
    ]
    
    runs.each do |args|
      res1 = arr.slice(*args)
      res2 = ae.slice(*args)
      
      raise "Expected res to be: #{res1} but got #{res2} for args '#{args}'." if res1 != res2
    end
    
    fails.each do |args|
      begin
        res2 = ae.slice(*args)
        raise "Should have failed but didnt."
      rescue
        #ignore.
      end
    end
  end
end
