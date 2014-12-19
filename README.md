# ArrayEnumerator

A modified enumerator for Ruby that behaves like an array, without loading everything into memory.

## Install

Add to your Gemfile and bundle:
```ruby
gem "ArrayEnumerator"
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

Call array-methods like you normally would:
```ruby
a_enum.empty? #=> false
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

