require 'aws-record'
require 'aws-sdk-resources'

class Reports
  def write(name, data)

    @@dynamodb = Aws::DynamoDB::Client.new

    items = []
    data.each do |d|
      item = {
          "report_name": name,
          "report_time": d[0],
          "report_value": d[1]
      }

      items.append({"put_request": {"item": item}})

      if items.count >= 25
        push(items)
        items = []
      end
    end

    # todo better code style (split items per 25 rows)
    if items.count >= 1
      push(items)
    end

    puts 'Written done'

  end

  def push(items)
    @@dynamodb.batch_write_item({"request_items": {'Reports': items}})
  end
end