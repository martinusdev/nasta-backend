$LOAD_PATH << 'lib'

require 'nasta/new_relic/new_relic_error_rate_martinus'
require 'nasta/model/reports'

def test
  data = NewRelicErrorRateMartinus.fetch
  puts data
    #Reports.write(data)
end

test