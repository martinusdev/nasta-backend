# frozen_string_literal: true
require 'net/http'
require 'json'
require 'time'
require 'nasta/service/new_relic_insights'

module NewRelic
  class FcpHomePage
    def fetch
      api = NewRelicInsights.new
      data = api.call 'SELECT percentile(firstContentfulPaint, 90)  FROM PageView SINCE 1 day AGO WHERE appName=\'Martinus\' AND name = \'WebTransaction/Custom/martinus/catalog.homepage:index\' FACET deviceType'
      results = []
      data['facets'].each do |res|
        results.append(['fcp_home_page_' + res['name'].downcase, Time.now.to_i, res['results'][0]['percentiles']['90']])
      end
      results
    end
  end
end