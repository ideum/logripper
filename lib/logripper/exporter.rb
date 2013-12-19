require 'csv'

module Logripper
  class Exporter
    attr_reader :parsed_log

    def initialize(parsed_log)
      @parsed_log = parsed_log
    end

    def to_csv
      CSV.generate do |csv|
        csv << parsed_log.first.keys
        parsed_log.each do |log_entry|
          csv << log_entry.values
        end
      end
    end
  end
end
