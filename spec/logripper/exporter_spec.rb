require 'spec_helper'
require 'logripper/exporter'

describe Logripper::Exporter do
  let(:parsed_log) {
    [
      {timestamp: DateTime.new(2013, 1, 1, 0, 0, 0), method: 'GET', url: '/test/1', status: 200},
      {timestamp: DateTime.new(2013, 1, 1, 0, 5, 0), method: 'GET', url: '/test/2', status: 200},
    ].lazy # logs are returned as lazy enumerators
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
