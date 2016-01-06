[![Code Climate](https://codeclimate.com/github/kaspernj/array_enumerator/badges/gpa.svg)](https://codeclimate.com/github/kaspernj/array_enumerator)
[![Test Coverage](https://codeclimate.com/github/kaspernj/array_enumerator/badges/coverage.svg)](https://codeclimate.com/github/kaspernj/array_enumerator)
[![Build Status](https://img.shields.io/shippable/540e7b993479c5ea8f9ec1fb.svg)](https://app.shippable.com/projects/540e7b993479c5ea8f9ec1fb/builds/latest)

# ArrayEnumerator

A modified enumerator for Ruby that behaves like an array, without loading everything into memory.

## Install

Add to your Gemfile and bundle:
```ruby
gem "array_enumerator"
```

## Usage

Use it like a normal enumerator:
```ruby
a_enum = ArrayEnumerator.new do |y|
  1_000.times do |count|
    y << count
  end
end
```

Or give it a normal Enumerator that already exists:
```ruby
enum = Enumerator.new do |y|
  1_000.times do |count|
    y << count
  end
end

a_enum = ArrayEnumerator.new(enum)
```

Call array-methods like you normally would:
```ruby
a_enum.empty? #=> false
a_enum.none? => false
a_enum.any? => true
a_enum.first #=> 1
a_enum.shift #=> 2
a_enum[2] #=> 3
a_enum.each_index { |count| puts "Count: #{count}" }
a_enum.length #=> 3
a_enum.select { |element| element.to_f }.to_a #=> [0.0, 1.0, 2.0 etc]
a_enum << 1001 # push also works
a_enum.unshift -1
a_enum.min #=> 0
a_enum.max #=> 999
```

### Collect

Prints out 100, 101 102 etc.
```ruby
collected_a_enum = a_enum.collect { |count| count + 100 }
collected_a_enum.each do |count|
  print "#{count} "
end
```

## Contributing to ArrayEnumerator

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Kasper Johansen. See LICENSE.txt for
further details.

