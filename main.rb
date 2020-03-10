require_relative 'lib/nasta/new_relic/new_relic_error_rate_martinus'
require_relative 'lib/nasta/model/reports'

def test
  data = NewRelicErrorRateMartinus.fetch
  puts data
    #Reports.write(data)
end

test