require "spec_helper"

describe "ArrayEnumerator" do
  it "can be initialized as normal enumerator" do
    enum = ArrayEnumerator.new do |y|
      3.times do |count|
        y << count
      end
    end

    3.times do |count|
      enum.shift.should eq count
    end
  end

  it "#shift" do
    cont = %w[a b c d e].to_enum
    ae = ArrayEnumerator.new(cont)
    ae.shift.should eq "a"
    ae.to_a.should eq %w[b c d e]
  end

  describe "#each" do
    it "should loop with correct values" do
      arr = %w[a b c]
      cont = arr.to_enum
      ae = ArrayEnumerator.new(cont)

      count = 0
      ae.each do |ele|
        ele.should eq arr[count]
        count += 1
      end

      count.should eq 3
    end
  end

  describe "#empty?" do
    it "be able to test empty and then loop correctly afterwards" do
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

      expect { ae.to_a }.to raise_error(ArrayEnumerator::ArrayCorruptedError)
      expect { ae.first }.to raise_error(ArrayEnumerator::ArrayCorruptedError)

      expect {
        ae.each { |ele| raise "Should never get here?" }
      }.to raise_error(ArrayEnumerator::ArrayCorruptedError)
    end

    it "still be able to get the first element after testing if empty" do
      cont = %w[a b c].to_enum
      ae = ArrayEnumerator.new(cont)
      ae.empty?.should eq false
      ae.first.should eq "a"
    end
  end

  it "#length" do
    cont = %w[a b c d e].to_enum
    ae = ArrayEnumerator.new(cont)

    expect { ae.length }.to raise_error(ArrayEnumerator::CannotCallBeforeEnd)

    ae.each do |ele|
      # ignore.
    end

    ae.length.should eq 5
  end

  it "#slice" do
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
      arr.slice(*args).should eq ae.slice(*args)
    end

    fails.each do |args|
      expect {
        res2 = ae.slice(*args)
        raise "Should have failed but didnt."
      }.to raise_error
    end
  end

  it "#each_index" do
    arr = %w[a b c d e f g]
    ae = ArrayEnumerator.new(arr.to_enum)

    expect = 0
    ae.each_index do |num|
      num.should eq expect
      ae[num].should eq arr[num]
      expect += 1
    end
  end

  it "#select" do
    enum = ArrayEnumerator.new do |y|
      10.times do |count|
        y << count
      end
    end

    result = enum.select { |element| element == 5}
    result.should eq [5]
  end
end
