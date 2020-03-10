$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'nasta/reports'
require 'logger'

def lambda_handler(event:, context:)
  report_name = event['report']

  return { statusCode: 400, body: "No report was specified" } if report_name.nil?

  begin
    class_name = Object.const_get(report_name)
  rescue NameError => e
    return { statusCode: 404, body: "Report #{report_name} not found" }
  end

  begin
    report = class_name.new
    report.fetch
    { statusCode: 200, body: '' }
  rescue StandardError => e
    logger = Logger.new $stderr
    logger.error e.full_message
    { statusCode: 500, body: "Failed to fetch data for report #{report_name}" }
  end
end
