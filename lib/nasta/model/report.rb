require 'aws-record'
class Report
  include Aws::Record
  string_attr :name
  integer_attr :timestamp
  float_attr :value
end