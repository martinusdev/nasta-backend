$LOAD_PATH << './lib'

require 'dotenv/load'
require 'nasta/new_relic/new_relic_error_rate_martinus'
require 'nasta/model/reports'
require 'nasta/scheduler'

def test
  report = NewRelicErrorRateMartinus.new

  data = report.fetch
  puts data
  db = Reports.new
  db.write('nr_error_rate_multi', data)
end

def schedule
  scheduler = Scheduler.new
  scheduler.schedule
end

#test
schedule
