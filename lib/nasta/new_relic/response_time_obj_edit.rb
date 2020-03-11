# frozen_string_literal: true
require 'net/http'
require 'json'
require 'time'
require 'nasta/service/new_relic_insights'

module NewRelic
  class ResponseTimeObjEdit
    def fetch
      api = NewRelicInsights.new
      data = api.call 'SELECT percentile(duration, 99) FROM Transaction SINCE 5 minutes AGO WHERE name LIKE \'%obj_edit%\' AND `request.method` = \'GET\''
      [['response_time_obj_edit', Time.now.to_i, data['results'][0]['percentiles']['99']]]
    end
  end
end