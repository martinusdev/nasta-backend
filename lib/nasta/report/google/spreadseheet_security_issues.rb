# require 'time'
require 'nasta/service/spreadsheet_api'

module Google
  class SpreadsheetSecurityIssues
    def fetch
      data = []

      # https://docs.google.com/spreadsheets/d/1k2WdD5sX6Lj1AEkw-_L-qcJQ7n2OmY8nHWZdkTtFDwM/edit
      # User from credentials need to access to current spreadsheet
      spreadsheet_id = '1k2WdD5sX6Lj1AEkw-_L-qcJQ7n2OmY8nHWZdkTtFDwM'
      range = 'Overview!J7:K200'
      response = GoogleSpreadSheetApi.new.spreadsheet_data(spreadsheet_id, range)

      raise 'No data found.' if response.values.empty?

      unsupported_count = 0
      unsecured_count = 0
      response.values.each do |row|
        unsupported_count += 1 if Date.parse(row[0]) < Date.today
        unsecured_count += 1 if Date.parse(row[1]) < Date.today
      end

      data.append(['unsupported_features', Time.now.to_i, unsupported_count])
      data.append(['unsecured_features', Time.now.to_i, unsecured_count])

      data
    end
  end
end