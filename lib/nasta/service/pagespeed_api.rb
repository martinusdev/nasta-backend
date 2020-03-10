require 'net/http'
require 'json'

class GooglePageSpeedApi
  BASE_URL = 'https://www.googleapis.com/pagespeedonline/v5'.freeze

  def pagespeed_request(target_url)
    # Documentation: https://developers.google.com/speed/docs/insights/v5/reference/pagespeedapi/runpagespeed
    # Generate API Keys: https://console.cloud.google.com/apis/credentials
    api_key = ENV['GOOGLE_PAGESPEED_API_KEY']
    uri = URI(BASE_URL + '/runPagespeed?url=' + target_url + '&key=' + api_key + '&strategy=mobile')
    req = Net::HTTP::Get.new(uri)

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    case res
    when Net::HTTPSuccess
      JSON.parse(res.body)
    else
      puts 'error'
      raise res.body
    end
  end
end