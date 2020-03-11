# frozen_string_literal: true
require 'google/apis/sheets_v4'
require 'googleauth'
require 'stringio'
require 'base64'

class GoogleSpreadSheetApi
  def authorize
    io = StringIO.open(Base64.decode64(ENV['GOOGLE_SPREADSHEET_CREDENTIALS_BASE64']))
    scope = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY
    Google::Auth::ServiceAccountCredentials.make_creds(json_key_io: io, scope: scope)
    # token = authorizer.fetch_access_token!  # if you want to test
  end

  def spreadsheet_data(spreadsheet_id, range)
    service = Google::Apis::SheetsV4::SheetsService.new
    service.client_options.application_name = 'Nasta backend'
    service.authorization = authorize
    service.get_spreadsheet_values spreadsheet_id, range
  end

end