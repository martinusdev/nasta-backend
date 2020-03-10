$LOAD_PATH << './lib'

require 'dotenv/load'
require 'nasta/new_relic/error_rate_martinus'
require 'nasta/model/reports'
require 'nasta/scheduler'

def test
  report = NewRelic::ErrorRateMartinus.new

  data = report.fetch
  puts data
  db = Reports.new
  db.write(data)
end

def schedule
  scheduler = Scheduler.new
  scheduler.schedule
end

#test
schedule
