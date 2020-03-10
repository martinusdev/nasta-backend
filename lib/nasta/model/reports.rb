require 'aws-sdk-resources'

class Reports
  def write(data)

    @@dynamodb = Aws::DynamoDB::Client.new

    items = []
    data.each do |d|
      item = {
          "report_name": d[0],
          "report_time": d[1],
          "report_value": d[2]
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
    puts "writing #{items.count} lines"
    @@dynamodb.batch_write_item({"request_items": {'Reports': items}})
  end
end