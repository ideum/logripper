require 'spec_helper'
require 'logripper/exporter'

describe Logripper::Exporter do
  let(:parsed_log) {
    [
      %w(timestamp method url status),
      [DateTime.new(2013, 1, 1, 0, 0, 0), 'GET', '/test/1', 200],
      [DateTime.new(2013, 1, 1, 0, 5, 0), 'GET', '/test/2', 200],
    ]
  }

  subject(:exporter) { Logripper::Exporter.new(parsed_log) }

  it "should export a CSV" do
    exporter.to_csv.should == <<-CSV
timestamp,method,url,status
2013-01-01T00:00:00+00:00,GET,/test/1,200
2013-01-01T00:05:00+00:00,GET,/test/2,200
    CSV
  end
end
