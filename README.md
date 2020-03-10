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

#### Implement
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

#### Return values

fetch should return array of `[timestamp, value]`, eg. 

```ruby
[
    [1583848560, 0.2],
    [1583848500, 0.3]
    [1583848440, 0.34]
]
```

#### Run

Add your report to:
- reports.rb
- config/reports.json

# Deploy
1. zbaliť adresáre `bin/` a `lib/` do ZIP súboru
2. nahrať do AWS lambda cez web

**WINDOWS** - máte WSL? pustite to v ňom :)

Jednorázový setup:
```bash
cd nasta-backend
chmod +x bin/build-zip
```

Vytvorenie zip:
```bash
cd nasta-backend
bin/build-zip
```
