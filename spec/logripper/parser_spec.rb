require 'spec_helper'
require 'logripper/parser'

describe Logripper::Parser do
  let(:log_pseudofile) { StringIO.new(<<-LOG_SNIPPET, 'r') }
64.49.91.30 - - [19/Dec/2013:17:12:02 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
173.163.247.62 - - [19/Dec/2013:17:12:06 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
173.163.247.62 - - [19/Dec/2013:17:12:12 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
109.248.39.187 - - [19/Dec/2013:17:12:20 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
54.247.188.179 - - [19/Dec/2013:17:12:22 +0000] "HEAD / HTTP/1.0" 200 0 "-" "NewRelicPinger/1.0 (370512)"
176.106.148.117 - - [19/Dec/2013:17:12:23 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
198.175.115.118 - - [19/Dec/2013:17:12:27 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
94.21.30.184 - - [19/Dec/2013:17:12:27 +0000] "GET /virtual_controllers HTTP/1.1" 200 26264 "https://gameplay.gestureworks.com/gameplay_forums/forums/installation-issues" "Mozilla/5.0 (Windows NT 6.2; WOW64; rv:25.0) Gecko/20100101 Firefox/25.0"
66.25.173.131 - - [19/Dec/2013:17:12:27 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
50.31.164.139 - - [19/Dec/2013:17:12:28 +0000] "HEAD / HTTP/1.0" 200 0 "-" "NewRelicPinger/1.0 (370512)"
  LOG_SNIPPET

  subject(:parser) { Logripper::Parser.new(log_pseudofile) }

  describe '#find' do
    subject(:results) { parser.find('/alive.txt') }

    it "filters by URL" do
      results.length.should == 7
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
