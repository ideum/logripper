require 'csv'
require 'google_drive'

module Logripper
  class Exporter
    def initialize(data)
      @data = data
    end

    def to_csv
      puts CSV.generate do |csv|
        data.each do |line|
          csv << line
        end
      end
    end

    def to_google_drive(worksheet_name, google_username: nil, google_password: nil)
      session = GoogleDrive.login(google_username, google_password)
      spreadsheet = session.spreadsheet_by_key('0AiIyFklsJxLxdFhtc0NIMTYwb3RUdk9TckhRZVhMakE')
      worksheet = spreadsheet.worksheet_by_title(worksheet_name)

      worksheet.max_rows = data.length
      worksheet.max_cols = data.first.length

      data.each.with_index do |row, row_id|
        row.each.with_index do |cell, col_id|
          worksheet[row_id + 1, col_id + 1] = cell
        end
      end

      worksheet.save()
    end

    private

    attr_reader :data
  end
end
