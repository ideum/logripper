require 'spec_helper'
require 'logripper/parser'

describe Logripper::Parser do
  let(:log_pseudofile) { StringIO.new(<<-LOG_SNIPPET, 'r') }
64.49.91.30 - - [19/Dec/2013:17:12:02 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
173.163.247.62 - - [19/Dec/2013:17:12:06 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
54.247.188.179 - - [19/Dec/2013:17:12:22 +0000] "HEAD / HTTP/1.0" 200 0 "-" "NewRelicPinger/1.0 (370512)"
  LOG_SNIPPET

  let(:malformed_log_pseudofile) { StringIO.new(<<-LOG_SNIPPET, 'r') }
64.49.91.30 - - [19/Dec/2013:17:12:02 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
This is an intentionally malformed row
  LOG_SNIPPET

  subject(:parser) { Logripper::Parser.new(log_pseudofile) }

  describe '#find' do
    subject(:results) { parser.find('/alive.txt') }

    it "filters by URL" do
      results.length.should == 2
    end

    it "handles malformed lines" do
      expect {
        Logripper::Parser.new(malformed_log_pseudofile).find('/alive.txt')
      }.to_not raise_error
    end

    describe 'returned info' do
      subject { results.first }
      
      its([:timestamp]) { should == DateTime.new(2013, 12, 19, 17, 12, 02) }
      its([:method])    { should == 'GET' }
      its([:url])       { should == '/alive.txt' }
      its([:status])    { should == 200 }
    end
  end
end
