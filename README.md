# StaleOptions

[![Build Status](https://travis-ci.org/digaev/stale_options.svg?branch=master)](https://travis-ci.org/digaev/stale_options) [![Coverage Status](https://coveralls.io/repos/github/digaev/stale_options/badge.svg?branch=master)](https://coveralls.io/github/digaev/stale_options?branch=master)

A gem for caching HTTP responses.

The gem was built with an idea to implement a class which will create options for `ActionController::ConditionalGet#stale?` method, without caring of type of object class.

___

* Installation
* Usage
  * Caching options
  * Examples
  * Controller helpers

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stale_options'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install stale_options
```

## Usage

There are three main classes, each class is designed to create options for the corresponding object class:

* `StaleOptions::ArrayOptions` - For caching Arrays.
* `StaleOptions::RelationOptions` - For caching relations `ActiveRecord::Relation`.
* `StaleOptions::ObjectOptions` - For caching any other objects.

There is also base class `StaleOptions::AbstractOptions`. Constructor of these classes looks like:

```ruby
def initialize(record, options = {})
...
end
```

* `record` - Basically any Ruby object. Arrays and relations are "specials".
* `options` - `Hash`. Caching options (see detailed description in corresponding section).

Here is the very basic example of usage:

```
[1] pry(main)> options = StaleOptions::RelationOptions.new(Item.all)
[2] pry(main)> options.to_h
=> {:etag=>"39f08c583b023142dd64b0922dfaefd4", :last_modified=>2018-07-04 18:05:22 UTC}
```

In order to help create different classes of `StaleOptions` for different objects there is method `StaleOptions.create`, so above example can be rewritten like:

```
[3] pry(main)> StaleOptions.create(Item.all)
=> {:etag=>"39f08c583b023142dd64b0922dfaefd4", :last_modified=>2018-07-04 18:05:22 UTC}
```

And this is the way how you'll use it in most cases :)

### Caching options

There are two options for caching:

* `:cache_by`
  * `String` or `Symbol`. A name of method which returns unique identifier of object for caching.
  * For arrays and relations if value is `itself`, then it will be cached "as it is" (relations will be converted to arrays by calling `#to_a`), otherwise this method will be called on each element. *Hint: To cache arrays of "simple" objects (e.g. `String` or `Numeric`) set it to `itself`*.
  * Default: `:updated_at`.
* `:last_modified`
  * `String` or `Symbol`. A name of method which returns an instance of `ActiveSupport::TimeWithZone`, `DateTime`, `Time`.
    * If `record` is a relation, then an attribute name.
    * If `record` is an `Array` or `Object`, then a method name.
  * `ActiveSupport::TimeWithZone`, `DateTime`, `Time` or `nil` to set `:last_modified`.
  * Default: `:updated_at`.

### Examples

```
[1] pry(main)> StaleOptions.create(Task.all, last_modified: :done_at)
=> {:etag=>"ce8d2fbc9b815937b59e8815d8a85c21", :last_modified=>2018-06-30 18:25:07 UTC}

[2] pry(main)> StaleOptions.create([1, 2, 3], cache_by: :itself, last_modified: nil)
=> {:etag=>"73250e72da5d8950b6bbb16044353d26", :last_modified=>nil}

[3] pry(main)> StaleOptions.create({ a: 'a', b: 'b', c: 'c' }, cache_by: :itself, last_modified: Time.now)
=> {:etag=>"fec76eca1192bc7371e44d517b56c93f", :last_modified=>2018-07-08 07:08:48 UTC}
```

### Controller helpers

In your controller:

```ruby
# To render a template:

class PostsController < ApplicationController
  include StaleOptions::Backend

  def index
    if_stale?(Post.all) do |posts|
      @posts = posts
    end
  end
end

# Or, to render json:

class PostsController < ApplicationController
  include StaleOptions::Backend

  def index
    if_stale?(Post.all) do |posts|
      render json: posts
    end
  end
end
```

Here we're using method `#if_stale?` (there is also `#unless_stale?` btw) which was added to controller by including `StaleOptions::Backend` module. The method accepts two arguments `record` and `options` (yeah, just like `StaleOptions.create`).

Under the hood it calls `ActionController::ConditionalGet#stale?` with options created by `StaleOptions.create`:

```ruby
def if_stale?(record, options = {})
  yield(record) if stale?(StaleOptions.create(record, options))
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/digaev/stale_options.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
