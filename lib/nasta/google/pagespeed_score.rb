# frozen_string_literal: true
require 'dotenv/load'
require 'net/http'
require 'json'
require 'time'
require 'aws-record'
require 'aws-sdk-resources'

class PageSpeedScore
  def pagespeed_api_request(target_url)
    # https://developers.google.com/speed/docs/insights/v5/reference/pagespeedapi/runpagespeed
    api_key = ENV['GOOGLE_PAGESPEED_API_KEY'] #todo fix - missing
    uri = URI('https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=' + target_url + '&key=' + api_key + '&strategy=mobile')
    req = Net::HTTP::Get.new(uri)

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
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

  def fetch
    data = []

    target_url = 'https://www.martinus.sk/knihy/proza-poezia'
    json = pagespeed_api_request(target_url)
    score = json['lighthouseResult']['categories']['performance']['score']
    fpc = json['loadingExperience']['metrics']['FIRST_CONTENTFUL_PAINT_MS']['percentile']
    data.append([Time.now, score])
    data.append([Time.now, fpc])

    target_url = 'https://www.martinus.sk/?uItem=194447'
    json = pagespeed_api_request(target_url)
    score = json['lighthouseResult']['categories']['performance']['score']
    fpc = json['loadingExperience']['metrics']['FIRST_CONTENTFUL_PAINT_MS']['percentile']
    data.append([Time.now, score])
    data.append([Time.now, fpc])

    data
  end
end

# PageSpeedScore.new.fetch