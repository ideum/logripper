require 'csv'

module Logripper
  class Exporter
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_csv
      CSV.generate do |csv|
        csv << data.first.keys
        data.each do |entry|
          csv << entry.values
        end
      end
    end
  end
end
