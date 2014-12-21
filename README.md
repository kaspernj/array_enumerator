[![Build Status](https://api.shippable.com/projects/540e7b993479c5ea8f9ec1fb/badge?branchName=master)](https://app.shippable.com/projects/540e7b993479c5ea8f9ec1fb/builds/latest)
[![Code Climate](https://codeclimate.com/github/kaspernj/array_enumerator/badges/gpa.svg)](https://codeclimate.com/github/kaspernj/array_enumerator)
[![Test Coverage](https://codeclimate.com/github/kaspernj/array_enumerator/badges/coverage.svg)](https://codeclimate.com/github/kaspernj/array_enumerator)

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
  # do something
end

a_enum = ArrayEnumerator.new(enum)
```

Call array-methods like you normally would:
```ruby
a_enum.empty? #=> false
a_enum.first #=> 1
a_enum.shift #=> 2
a_enum[2] #=> 3
a_enum.each_index { |count| puts "Count: #{count}" }
a_enum.length #=> 3
results_array = a_enum.select { |element| element.something? }
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

