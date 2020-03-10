# Nasta Backend

### Install
```shell script
bundle config set path 'vendor/bundle'
bundle install
```

### ENV
Setup this env variables:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_REGION = eu-central-1
* NR_API_KEY

### Report classes

Treba implementovať nasledujúcu triedu:

```ruby
# lib/nasta/some_report.rb

class SomeReport
  def fetch
    # ...
  end
end
```

V prípade chyby treba hodiť `StandardError` alebo jej podtriedu, lambda vráti chybovú odpoveď. 

<small>[Understanding the Ruby Exception Hierarchy](https://www.honeybadger.io/blog/understanding-the-ruby-exception-hierarchy/)</small>