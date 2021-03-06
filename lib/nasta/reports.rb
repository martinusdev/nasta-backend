require 'nasta/dummy/success_report'
require 'nasta/dummy/error_report'
require 'nasta/new_relic/error_rate_martinus'
require 'nasta/new_relic/error_rate_admin'
require 'nasta/new_relic/error_rate_background_jobs'
require 'nasta/new_relic/response_time_pda'
require 'nasta/new_relic/response_time_obj_edit'
require 'nasta/new_relic/fcp_home_page'
require 'nasta/new_relic/fcp_detail'
require 'nasta/report/google/pagespeed_category'
require 'nasta/report/google/pagespeed_product'
require 'nasta/github/test_count_report'
require 'nasta/report/google/spreadseheet_security_issues'

class Reports
  def self.create(name)
    begin
      class_name = Object.const_get(name)
    rescue StandardError => e
      raise "Report #{name} not found"
    end

    class_name.new
  end
end
