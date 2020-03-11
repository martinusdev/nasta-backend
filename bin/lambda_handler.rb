$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'nasta/reports'
require 'logger'
require 'nasta/model/reports'
require 'lib/nasta/scheduler'

def lambda_handler(event:, context:)
  puts event

  if event['Records']
    run_report event
  elsif event['frequency']
    schedule event['frequency']
  else
    raise 'unknown method'
  end
end

def run_report(event)
  raise 'Not implemented for multiple entries' unless event['Records'].count == 1

  report_name = event['Records'][0]['body']
  raise 'No report was specified' if report_name.nil?

  report = Reports.create(report_name)

  reports = Reports.new
  reports.write(report.fetch)

  {statusCode: 200, body: ''}
end

def schedule(frequency)
  scheduler = Scheduler.new
  scheduler.schedule frequency
end