require 'aws-sdk-resources'

class Scheduler
  def read_reports
    file = File.read('config/reports.json')
    JSON.parse(file)
  end

  def schedule
    reports = read_reports
    # todo - frequency

    items = [{
                 message_group_id: 'test2',
                 id: 'test2',
                 message_body: {'this': 'should_fail'}.to_s,
             }]
    reports.each_key { |report_name|
      report = reports[report_name]
      puts report_name
      puts report
      items.append({
                       message_group_id: report_name, #todo correct value
                       id: report_name, #todo correct value
                       message_body: {report: report_name}.to_s, #todo correct value
                   })
    }

    sqs_push items
    puts 'scheduled'
  end

  def sqs_push (items)
    sqs = Aws::SQS::Client.new
    sqs.send_message_batch({queue_url: ENV['SQS_QUEUE'], entries: items})
  end
end
