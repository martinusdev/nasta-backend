require 'time'
require 'nasta/service/pagespeed_api'

module Google
  class PageSpeedCategory
    def fetch
      data = []

      target_url = 'https://www.martinus.sk/knihy/proza-poezia'
      json = GooglePageSpeedApi.new.pagespeed_request(target_url)
      score = json['lighthouseResult']['categories']['performance']['score']
      fcp = json['loadingExperience']['metrics']['FIRST_CONTENTFUL_PAINT_MS']['percentile']
      data.append(['pagespeed_product_category', Time.now.to_i, score])
      data.append(['pagespeed_product_category', Time.now.to_i, fcp])

      data
    end
  end
end