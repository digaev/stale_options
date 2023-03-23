# StaleOptions

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/digaev/stale_options/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/digaev/stale_options/tree/master)
[![Coverage Status](https://coveralls.io/repos/github/digaev/stale_options/badge.svg?branch=master)](https://coveralls.io/github/digaev/stale_options?branch=master)
[![Gem Version](https://badge.fury.io/rb/stale_options.svg)](https://badge.fury.io/rb/stale_options)

A gem for caching HTTP responses.

The gem was built with an idea to implement a class which will create options for the `ActionController::ConditionalGet#stale?` method. It allows to cache any kind of objects, not only records or collections (unlike of `#stale?`).

___

* [Installation](#installation)
* [Usage](#usage)
  * [Caching options](#caching-options)
  * [Examples](#examples)
  * [Controller helpers](#controller-helpers)
* [Contributing](#contributing)
* [License](#license)

## Installation

Add one of these lines to your application's Gemfile depending on your Rails version:

```ruby
# Rails 5.2
gem 'stale_options', '~> 1.0.0'

# Rails 6.0
gem 'stale_options', '~> 1.1.0'

# Rails 6.1
gem 'stale_options', '~> 1.2.0'

# Rails 7.0
gem 'stale_options', '~> 1.3.0'
```

And then execute:

```sh
bundle install
```

## Usage

```
StaleOptions.create(Item.all)
=> {:etag=>"39f08c583b023142dd64b0922dfaefd4", :last_modified=>2018-07-04 18:05:22 UTC}
```

The method also acceppts an optional second parameter (see Caching options).

### Caching options

There are two options for caching, `cache_by` and `last_modified`:

* `:cache_by`
  * `String` or `Symbol`. The name of the method that returns the unique identifier of the object for caching, which is used to set `etag` of the resulting options. Set it to `itself` if you don't have such a method (see example below) and the gem will generate one for you.
  * Default: `:updated_at`.
* `:last_modified`
  * `String` or `Symbol`. The name of the method that returns an instance of `ActiveSupport::TimeWithZone`, `DateTime`, `Time`.
  * `ActiveSupport::TimeWithZone`, `DateTime`, `Time` or `nil` to set `:last_modified` directly.
  * Default: `:updated_at`.

### Examples

```
StaleOptions.create(Task.all, last_modified: :done_at)
=> {:etag=>"ce8d2fbc9b815937b59e8815d8a85c21", :last_modified=>2018-06-30 18:25:07 UTC}

StaleOptions.create([1, 2, 3], cache_by: :itself, last_modified: nil)
=> {:etag=>"73250e72da5d8950b6bbb16044353d26", :last_modified=>nil}

StaleOptions.create({ a: 'a', b: 'b', c: 'c' }, cache_by: :itself, last_modified: Time.now)
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

Here we're using the `#if_stale?` method which was added to the controller by including the `StaleOptions::Backend` module. The method accepts two arguments `record` and `options` (yeah, just like `StaleOptions.create`).

Under the hood, it calls `ActionController::ConditionalGet#stale?` with options created by `StaleOptions.create`:

```ruby
def if_stale?(record, options = {})
  yield(record) if stale?(StaleOptions.create(record, options))
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/digaev/stale_options.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
