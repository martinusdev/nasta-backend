# frozen_string_literal: true
require 'net/http'
require 'json'
require 'time'

module NewRelic
  class ErrorRateMartinus
    def newrelic_request
      from = Time.now - 60*5
      to = Time.now
      path = "https://api.newrelic.com/v2/applications/#{ENV['NR_APP_ID_MARTINUS']}/metrics/data.json?names[]=WebTransaction&names[]=Errors%2Fall&from=#{from.iso8601(0)}&to=#{to.iso8601(0)}"
      puts path
      uri = URI(path)
      req = Net::HTTP::Get.new(uri)
      req.add_field 'X-Api-Key', ENV['NR_API_KEY']

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end

      case res
      when Net::HTTPSuccess
        JSON.parse(res.body)
      else
        raise res.body
      end
    end

    def fetch
      json = newrelic_request
      transactions = json['metric_data']['metrics'][0]['timeslices']
      errors = json['metric_data']['metrics'][1]['timeslices']

      errors_count = {}
      errors.each { |d| errors_count[d['from']] = d['values']['error_count'] }
      data = []
      transactions.each do |d|
        calls = d['values']['call_count']
        errors = errors_count[d['from']]
        data.append([
                        'error_rate_martinus',
                        Time.parse(d['from']).to_i,
                        (errors / calls.to_f * 1000).to_f
                    ])
      end
      data
    end
  end
end
