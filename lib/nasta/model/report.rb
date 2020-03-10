require 'aws-record'
class Report
  include Aws::Record
  string_attr :report_name
  integer_attr :report_time
  float_attr :report_value
end