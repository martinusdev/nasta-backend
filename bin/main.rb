$LOAD_PATH << 'lib'

require 'nasta/new_relic/new_relic_error_rate_martinus'
require 'nasta/model/reports'

def test
  report = NewRelicErrorRateMartinus.new

  data = report.fetch
  puts data
  db = Reports.new
  db.write('nr_error_rate_martinus', data)
end

test