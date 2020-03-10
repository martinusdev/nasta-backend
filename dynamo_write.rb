require 'json'
require 'aws-sdk'

dynamo_user_id = '' # <----------- insert
dynamo_user_secret = '' # <----------- insert
dynamo_region = 'eu-central-1'

Aws.config.update({
                      access_key_id: dynamo_user_id,
                      secret_access_key: dynamo_user_secret,
                      region: dynamo_region
                      # on production will be:
                      # region: dynamo_region,
                      # endpoint: 'http://localhost:8000'
                  })

dynamodb = Aws::DynamoDB::Client.new
table_name = 'Reports'

file = File.read('report.json')
movies = JSON.parse(file)
movies.each { |item|

  params = {
      table_name: table_name,
      item: item
  }

  begin
    dynamodb.put_item(params)
    puts "Added report item: #{item["Name"]}"

  rescue Aws::DynamoDB::Errors::ServiceError => error
    puts 'Unable to add report item:'
    puts "#{error.message}"
  end
}
