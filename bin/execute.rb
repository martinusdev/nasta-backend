$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'dotenv/load'
require 'nasta/reports'

raise "Usage: debug.rb ReportClassName" unless ARGV[0].is_a? String

report = Reports.create(ARGV[0])
puts report.fetch.inspect
