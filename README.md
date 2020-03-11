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

fetch should return array of `[name, timestamp, value]`, eg.

```ruby
[
    ['error_rate_martinus', 1583848560, 0.2],
    ['error_rate_martinus', 1583848500, 0.32],
    ['error_rate_other', 1583848560, 0.01],
    ['error_rate_other', 1583848500, 0.04]
]
```

#### Run

Add your report to:
- reports.rb
- config/reports.json

# Deploy
1. pack folders `bin/` and `lib/` to ZIP file
2. upload to AWS lambda via web-browser

**WINDOWS** - do you have WSL? run in it :)

First-time setup:
```bash
cd nasta-backend
chmod +x bin/build-zip
```

Creating zip:
```bash
cd nasta-backend
bin/build-zip
```
