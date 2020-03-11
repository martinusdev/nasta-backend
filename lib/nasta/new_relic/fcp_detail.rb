# frozen_string_literal: true
require 'net/http'
require 'json'
require 'time'
require 'nasta/service/new_relic_insights'

module NewRelic
  class FcpDetail
    def fetch
      api = NewRelicInsights.new
      data = api.call 'SELECT percentile(firstContentfulPaint, 90)  FROM PageView SINCE 1 day AGO WHERE appName=\'Martinus\' AND name = \'WebTransaction/Custom/martinus/catalog.products:view\' FACET deviceType'
      results = []
      data['facets'].each do |res|
        results.append(['fcp_detail_' + res['name'].downcase, Time.now.to_i, res['results'][0]['percentiles']['90']])
      end
      results
    end
  end
end