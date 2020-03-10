require 'nasta/reports'

def lambda_handler(event:, context:)
  report_name = event['report']

  return { statusCode: 400, body: 'No report was specified' } if report_name.nil?

  begin
    class_name = Object.const_get(report_name)
  rescue NameError => e
    return { statusCode: 404, body: 'Report #{report_name} not found' }
  end

  begin
    report = class_name.new
    report.fetch
    { statusCode: 200, body: '' }
  rescue StandardError => e
    # todo logging
    { statusCode: 500, body: 'Failed to fetch data for report #{report_name}' }
  end
end
