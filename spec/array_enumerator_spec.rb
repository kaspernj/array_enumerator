require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ArrayEnumerator" do
  it "shift" do
    cont = %w[a b c d e].to_enum
    ae = ArrayEnumerator.new(cont)
    ae.shift.should eq "a"
    ae.to_a.should eq %w[b c d e]
  end

  it "each" do
    arr = %w[a b c]
    cont = arr.to_enum
    ae = ArrayEnumerator.new(cont)

    count = 0
    ae.each do |ele|
      ele.should eq arr[count]
      count += 1
    end

    count.should eq 3

    arr = %w[a b c]
    cont = arr.to_enum
    ae = ArrayEnumerator.new(cont)

    ae.empty?.should eq false

    count = 0
    ae.each do |ele|
      ele.should eq arr[count]
      count += 1
    end

    count.should eq 3

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
    ae = ArrayEnumerator.new(cont)

    res = ae.empty?
    raise "Expected empty to be false but got: '#{res}'." if res != false

    first = ae.first
    raise "Expected first to be 'a' but it wasnt: '#{first}'." if first != "a"
  end

  it "length" do
    cont = %w[a b c d e].to_enum
    ae = ArrayEnumerator.new(cont)

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
    ae = ArrayEnumerator.new(cont)

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

  it "each_index" do
    arr = %w[a b c d e f g]
    ae = ArrayEnumerator.new(arr.to_enum)

    expect = 0
    ae.each_index do |num|
      raise "Expected #{expect} but got: #{num}" if num != expect
      ele = ae[num]
      raise "Expected #{arr[num]} but got: #{ele}" if ele != arr[num]
      expect += 1
    end
  end
end
