require 'net/http'
require 'json'

class NewRelicInsights
  def call(query)
    path = "https://insights-api.newrelic.com/v1/accounts/#{ENV['NR_ACCOUNT_ID']}/query?nrql=" + CGI::escape(query)
    puts path
    puts ENV['NR_QUERY_KEY']
    uri = URI(path)
    req = Net::HTTP::Get.new(uri)
    req.add_field 'X-Query-Key', ENV['NR_QUERY_KEY']

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end

    case res
    when Net::HTTPSuccess
      JSON.parse(res.body)['results']
    else
      raise res.body
    end
  end
end