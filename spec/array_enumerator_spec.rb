require "spec_helper"

describe "ArrayEnumerator" do
  let(:a_enum_10) do
    ArrayEnumerator.new do |y|
      10.times do |count|
        y << count
      end
    end
  end

  it "can be initialized as normal enumerator" do
    enum = ArrayEnumerator.new do |y|
      3.times do |count|
        y << count
      end
    end

    3.times do |count|
      expect(enum.shift).to eq count
    end
  end

  it "#shift" do
    cont = %w[a b c d e].to_enum
    ae = ArrayEnumerator.new(cont)
    expect(ae.shift).to eq "a"
    expect(ae.to_a).to eq %w[b c d e]
  end

  describe "#each" do
    it "should loop with correct values" do
      arr = %w[a b c]
      cont = arr.to_enum
      ae = ArrayEnumerator.new(cont)

      count = 0
      ae.each do |ele|
        expect(ele).to eq arr[count]
        count += 1
      end

      expect(count).to eq 3
    end
  end

  describe "#empty?" do
    it "be able to test empty and then loop correctly afterwards" do
      arr = %w[a b c]
      cont = arr.to_enum
      ae = ArrayEnumerator.new(cont)

      expect(ae.empty?).to eq false
      expect(ae.none?).to eq false
      expect(ae.any?).to eq true

      count = 0
      ae.each do |ele|
        expect(ele).to eq arr[count]
        count += 1
      end

      expect(count).to eq 3

      expect { ae.to_a }.to raise_error(ArrayEnumerator::ArrayCorruptedError)
      expect { ae.first }.to raise_error(ArrayEnumerator::ArrayCorruptedError)

      expect { ae.each { |ele| raise "Should never get here?" } }.to raise_error(ArrayEnumerator::ArrayCorruptedError)
    end

    it "still be able to get the first element after testing if empty" do
      cont = %w[a b c].to_enum
      ae = ArrayEnumerator.new(cont)
      expect(ae.empty?).to eq false
      expect(ae.none?).to eq false
      expect(ae.any?).to eq true
      expect(ae.first).to eq "a"
    end
  end

  it "#length" do
    cont = %w[a b c d e].to_enum
    ae = ArrayEnumerator.new(cont)

    expect { ae.length }.to raise_error(ArrayEnumerator::CannotCallBeforeEnd)

    ae.each do |ele|
      # ignore.
    end

    expect(ae.length).to eq 5
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
      expect(arr.slice(*args)).to eq ae.slice(*args)
    end

    fails.each do |args|
      expect {
        res2 = ae.slice(*args)
        raise "Should have failed but didnt."
      }.to raise_error(ArgumentError)
    end
  end

  it "#each_index" do
    arr = %w[a b c d e f g]
    ae = ArrayEnumerator.new(arr.to_enum)

    expect = 0
    ae.each_index do |num|
      expect(num).to eq expect
      expect(ae[num]).to eq arr[num]
      expect += 1
    end
  end

  it "#select" do
    result = a_enum_10.select { |element| element == 5 || element == 7 }
    expect(result.class).to eq ArrayEnumerator
    expect(result.to_a).to eq [5, 7]
  end

  it "#reject" do
    result = a_enum_10.reject { |element| element == 5 || element == 7}
    expect(result.class).to eq ArrayEnumerator
    expect(result.to_a).to eq [0, 1, 2, 3, 4, 6, 8, 9]
  end

  it "#compact" do
    a_enum = ArrayEnumerator.new([0, nil, 1, 2, 3, 4, nil, 5].to_enum)
    expect(a_enum.compact.to_a).to eq [0, 1, 2, 3, 4, 5]
  end

  describe "#collect" do
    it "should return a new enumerator yielding the new values one by one" do
      collected_a_enum = a_enum_10.collect { |element| element + 1000 }
      expect(collected_a_enum.class).to eq ArrayEnumerator

      count = 0
      collected_a_enum.each do |number|
        expect(number).to eq (count + 1000)
        count += 1
      end

      expect(count).to eq 10
    end

    it "should work with map and block-symbols" do
      collected_a_enum = a_enum_10.map(&:to_f)

      count = 0
      collected_a_enum.each do |number|
        expect(number).to eq count.to_f
        count += 1
      end

      expect(count).to eq 10
    end
  end

  describe '#push' do
    it 'adds extra objects' do
      a_enum_10.push 10

      count = 0
      a_enum_10.each do |number|
        expect(count).to eq number
        count += 1
      end

      expect(count).to eq 11
    end

    it 'doesnt allow push after end has been reached' do
      a_enum_10.each do
        # do nothing
      end

      expect { a_enum_10 << 10 }.to raise_error(ArrayEnumerator::ArrayCorruptedError)
    end
  end

  describe '#unshift' do
    it 'prepends objects' do
      a_enum_10.unshift -1

      count = -1
      a_enum_10.each do |number|
        expect(count).to eq number
        count += 1
      end

      expect(count).to eq 10
    end

    it 'doesnt allow unshift after starting iteration' do
      a_enum_10.each { }
      expect { a_enum_10.unshift -1 }.to raise_error(ArrayEnumerator::ArrayCorruptedError)
    end
  end

  it '#max' do
    expect(a_enum_10.max).to eq 9
  end

  it '#min' do
    expect(a_enum_10.min).to eq 0
  end

  it '#minmax' do
    expect(a_enum_10.minmax).to eq [0, 9]
  end
end
