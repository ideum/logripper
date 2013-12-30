require 'spec_helper'
require 'logripper/parser'

describe Logripper::Parser do
  let(:log_pseudofile) { StringIO.new(<<-LOG_SNIPPET, 'r') }
64.49.91.30 - - [19/Dec/2013:17:12:02 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
173.163.247.62 - - [19/Dec/2013:17:12:06 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
173.163.247.65 - - [20/Dec/2013:14:51:26 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
54.247.188.179 - - [19/Dec/2013:17:12:22 +0000] "HEAD / HTTP/1.0" 200 0 "-" "NewRelicPinger/1.0 (370512)"
  LOG_SNIPPET

  let(:malformed_log_pseudofile) { StringIO.new(<<-LOG_SNIPPET, 'r') }
64.49.91.30 - - [19/Dec/2013:17:12:02 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
This is an intentionally malformed row
  LOG_SNIPPET

  let(:parser) { Logripper::Parser.new(log_pseudofile) }

  describe '#parsed_lines' do
    let(:results) { parser.parsed_lines.force }

    it "reads the data" do
      results.length.should == 4
    end

    describe 'returned info' do
      subject { results.first }
      
      its([:ip_address]) { should == '64.49.91.30' }
      its([:timestamp])  { should == DateTime.new(2013, 12, 19, 17, 12, 02) }
      its([:method])     { should == 'GET' }
      its([:url])        { should == '/alive.txt' }
      its([:status])     { should == 200 }
      its([:bytes_sent]) { should == 6 }
      its([:referrer])   { should be_nil }
      its([:useragent])  { should be_nil }
    end

    context "malformed lines" do
      let(:parser) { Logripper::Parser.new(malformed_log_pseudofile) }

      it "skips malformed lines" do
        results.length.should == 1
      end
    end
  end
end
