require 'logripper/parser'

module Logripper
  class Importer
    attr_reader :db

    def initialize(log_file, db = "tmp/test.db")
      @log_file = Parser.new log_file

      @db = SQLite3::Database.new db

      @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS log_entries (
          ip_address VARCHAR(15) NOT NULL,
          timestamp INTEGER NOT NULL,
          method VARCHAR(10) NOT NULL,
          url VARCHAR(255) NOT NULL,
          status INTEGER NOT NULL,
          bytes_sent INTEGER NOT NULL,
          referer VARCHAR(255),
          useragent VARCHAR(255)
        )
      SQL
    end

    def import
      max_timestamp = @db.get_first_value(<<-SQL) || -Float::INFINITY
        SELECT MAX(timestamp) FROM log_entries
      SQL

      @log_file.parsed_lines.each do |line|
        line_timestamp = line[:timestamp].strftime('%s').to_i

        next if line_timestamp < max_timestamp

        @db.prepare <<-SQL do |stmt|
          INSERT INTO log_entries VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        SQL
          stmt.execute(
            line[:ip_address],
            line_timestamp,
            line[:method],
            line[:url],
            line[:status],
            line[:bytes_sent],
            line[:referer],
            line[:useragent]
          )
        end
      end
    end
  end
end
