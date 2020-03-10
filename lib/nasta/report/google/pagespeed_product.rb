require 'time'
require 'nasta/service/pagespeed_api'

class PageSpeedProduct
  def fetch
    data = []

    target_url = 'https://www.martinus.sk/?uItem=194447'
    json = GooglePageSpeedApi.new.pagespeed_request(target_url)
    score = json['lighthouseResult']['categories']['performance']['score']
    fpc = json['loadingExperience']['metrics']['FIRST_CONTENTFUL_PAINT_MS']['percentile']
    data.append([Time.now, score])
    data.append([Time.now, fpc])

    data
  end
end