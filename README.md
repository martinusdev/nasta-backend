# Nasta Backend

### Install
```shell script
bundle config set path 'vendor/bundle'
bundle install
```

### ENV (Development)
Copy .env.example to .env and change values inside file.

### ENV (AWS)
Setup variables from .env.example to AWS Lamda.

### Report classes

You need to implement following class:

```ruby
# lib/nasta/some_report.rb

class SomeReport
  def fetch
    # ...
  end
end
```

In case of Error you need to throw `StandardError` or its subclass, Lambda returns error response.

<small>[Understanding the Ruby Exception Hierarchy](https://www.honeybadger.io/blog/understanding-the-ruby-exception-hierarchy/)</small>