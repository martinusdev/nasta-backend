require 'aws-sdk-resources'

class Reports
  def write(data)
    return if data.empty?

    data = data.map { |row|
      item = {
          "report_name": row[0],
          "report_time": row[1],
          "report_value": row[2]
      }
      {"put_request": {"item": item}}
    }

    dynamo_db = Aws::DynamoDB::Client.new
    data.each_slice(25).each { |items|
      dynamo_db.batch_write_item({"request_items": {'Reports': items}})
    }
  end
end