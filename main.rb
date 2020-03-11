$LOAD_PATH << './lib'

require 'dotenv/load'
require 'nasta/new_relic/error_rate_martinus'
require 'nasta/new_relic/error_rate_background_jobs'
require 'nasta/new_relic/response_time_obj_edit'
require 'nasta/new_relic/fcp_home_page'
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
  scheduler.schedule daily
end

puts 'ide'


nr = NewRelic::FcpHomePage.new
puts nr.fetch


#test
#schedule
