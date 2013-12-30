require 'csv'

module Logripper
  class Exporter
    def initialize(data)
      @data = data
    end

    def to_csv
      CSV.generate do |csv|
        data.each do |line|
          csv << line
        end
      end
    end

    private

    attr_reader :data
  end
end
