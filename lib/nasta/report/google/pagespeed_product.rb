require 'time'
require 'nasta/service/pagespeed_api'

module Google
  class PageSpeedProduct
    def fetch
      data = []

      target_url = 'https://www.martinus.sk/?uItem=194447'
      json = GooglePageSpeedApi.new.pagespeed_request(target_url)
      score = json['lighthouseResult']['categories']['performance']['score']
      fcp = json['loadingExperience']['metrics']['FIRST_CONTENTFUL_PAINT_MS']['percentile']
      data.append(['pagespeed_product_score', Time.now.to_i, score])
      data.append(['pagespeed_product_fcp', Time.now.to_i, fcp])

      data
    end
  end
end