require 'aws-record'
class Reports
  include Aws::Record
  string_attr :name
  integer_attr :timestamp
  float_attr :value
end