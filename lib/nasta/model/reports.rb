require 'aws-record'
require 'aws-sdk-resources'

class Reports
  def write(name, data)

    dynamodb = Aws::DynamoDB::Client.new
    table_name = 'Reports'

    data.each do |d|
      item = {
          report_name: name,
          report_time: d[0],
          report_value: d[1]
      }

      params = {
          table_name: table_name,
          item: item
      }
      begin
        dynamodb.put_item(params)
        puts "Added item  #{d[0]}"

      rescue Aws::DynamoDB::Errors::ServiceError => error
        puts 'Unable to add item:'
        puts "#{error.message}"
      end
    end
  end
end