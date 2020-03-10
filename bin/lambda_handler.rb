$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'nasta/reports'
require 'logger'
require 'nasta/model/reports'

def lambda_handler(event:, context:)
  raise 'Not implemented for multiple entries' unless event['Records'].count == 1

  report_name = event['Records'][0]['body']

  raise 'No report was specified' if report_name.nil?

  begin
    class_name = Object.const_get(report_name)
  rescue NameError => e
    raise "Report #{report_name} not found"
  end

  begin
    report = class_name.new
    data = report.fetch
    puts 'fetched'
    reports = Reports.new
    reports.write(data)
    puts 'written'
    { statusCode: 200, body: '' }
  rescue StandardError => e
    logger = Logger.new $stderr
    logger.error e.full_message
    raise e
  end
end
