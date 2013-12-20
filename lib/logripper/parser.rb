module Logripper
  class Parser
    attr_reader :log_file

    def initialize(log_file)
      @log_file = log_file
    end

    def find(url)
      parsed_lines.find_all do |line|
        line[:url] == url
      end
    end

    def filter_by_date(url)
      find(url).reduce(Hash.new(0)) do |dates, line|
        date = line[:timestamp].to_date
        dates[date] += 1
        dates
      end.map do |date, count|
        {date: date, count: count}
      end
    end

    private

    COMMON_LOG_FORMAT_REGEX = %r{\A
      (?<ip_address>\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})
      \s-\s-\s
      \[(?<timestamp>\d{2}/\w{3}/\d{4}:\d{2}:\d{2}:\d{2}\s[+-]\d{4})\]\s
      "(?<method>[A-Z]+)\s(?<url>.+)\sHTTP/1\.[01]"\s
      (?<status>\d{3})\s
      (?<bytes_sent>\d+)\s
      (["](?<refferer>(\-)|(.+))["])\s
      (["](?<useragent>.+)["])
    \Z}x

    def parsed_lines
      log_file.each_line.lazy.map do |line|
        parsed_line = COMMON_LOG_FORMAT_REGEX.match(line) or next
        {
          timestamp: DateTime.strptime(parsed_line[:timestamp], '%d/%b/%Y:%H:%M:%S %z'),
          method: parsed_line[:method],
          url: parsed_line[:url],
          status: parsed_line[:status].to_i
        }
      end.reject(&:nil?)
    end
  end
end
