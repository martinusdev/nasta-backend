require 'aws-sdk-resources'

class Scheduler
  def read_reports
    file = File.read('config/reports.json')
    JSON.parse(file)
  end

  def schedule
    reports = read_reports
    # todo - frequency

    items = []
    reports.each_key { |report_name|
      report = reports[report_name]
      puts report_name
      puts report
      items.append({
                       message_group_id: (Digest::SHA2.hexdigest report_name), #todo correct value
                       id: (Digest::SHA2.hexdigest report_name), #todo correct value
                       message_body: report_name,
                   })
    }

    sqs_push items
    puts 'scheduled'
    puts items
  end

  def sqs_push (items)
    sqs = Aws::SQS::Client.new
    sqs.send_message_batch({queue_url: ENV['SQS_QUEUE'], entries: items})
  end
end

