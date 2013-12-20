require 'thor'
require 'logripper'

module Logripper
  class CLI < Thor
    package_name 'logripper'
    
    desc "extract URL LOG", "extracts all lines matching URL from LOG"
    def extract(url, log)
      log_file = File.open(log, 'r')
      parsed_log = Parser.new(log_file).find(url)
      puts Exporter.new(parsed_log).to_csv
    end

    desc "hitcount URL LOG", "returns counts of hits per day to the specified URL"
    def hitcount(url, log)
      log_file = File.open(log, 'r')
      data = Parser.new(log_file).filter_by_date(url)
      puts Exporter.new(data).to_csv
    end
  end
end
