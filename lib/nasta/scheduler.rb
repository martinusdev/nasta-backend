# frozen_string_literal: true
require 'aws-sdk-resources'

class Scheduler
  def read_reports
    file = File.read('config/reports.json')
    JSON.parse(file)
  end

  def schedule(frequency)
    reports = read_reports
    items = []
    reports.each_key do |report_name|
      report = reports[report_name]
      next unless report['frequency'] == frequency
      items.append({
                       message_group_id: (Digest::SHA2.hexdigest report_name), #TODO: correct value
                       id: (Digest::SHA2.hexdigest report_name), #TODO: correct value
                       message_body: report_name
                   })
    end

    sqs_push items unless items.count == 0
  end

  def sqs_push (items)
    sqs = Aws::SQS::Client.new
    sqs.send_message_batch({queue_url: ENV['SQS_QUEUE'], entries: items})
  end
end

