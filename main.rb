require 'lib/nasta/new_relic/new_relic_error_rate_martinus'
require 'lib/nasta/model/reports'

def test
  data = NewRelicErrorRateMartinus.fetch
  Reports.write(data)
end

test