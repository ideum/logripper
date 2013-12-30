module Logripper
  class Parser
    attr_reader :log_file

    COMMON_LOG_FORMAT_REGEX = %r{\A
      (?<ip_address>\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})
      \s-\s-\s
      \[(?<timestamp>\d{2}/\w{3}/\d{4}:\d{2}:\d{2}:\d{2}\s[+-]\d{4})\]\s
      "(?<method>[A-Z]+)\s(?<url>.+)\sHTTP/1\.[01]"\s
      (?<status>\d{3})\s
      (?<bytes_sent>\d+)\s
      (["](?<referer>(\-)|(.+))["])\s
      (["](?<useragent>.+)["])
    \Z}x

    def initialize(log_file)
      @log_file = log_file
    end

    def parsed_lines
      log_file.each_line.lazy.map do |line|
        parsed_line = COMMON_LOG_FORMAT_REGEX.match(line) or next
        {
          ip_address: parsed_line[:ip_address],
          timestamp: DateTime.strptime(parsed_line[:timestamp], '%d/%b/%Y:%H:%M:%S %z'),
          method: parsed_line[:method],
          url: parsed_line[:url],
          status: parsed_line[:status].to_i,
          bytes_sent: parsed_line[:bytes_sent].to_i,
          referer: parsed_line[:referer] == '-' ? nil : parsed_line[:referer],
          useragent: parsed_line[:useragent] == '-' ? nil : parsed_line[:useragent]
        }
      end.reject(&:nil?)
    end
  end
end
