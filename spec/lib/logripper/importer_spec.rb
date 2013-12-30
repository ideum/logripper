require 'spec_helper'
require 'logripper/importer'

describe Logripper::Importer do
  let(:log_pseudofile) { StringIO.new(<<-LOG_SNIPPET, 'r') }
64.49.91.30 - - [19/Dec/2013:17:12:02 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
173.163.247.62 - - [19/Dec/2013:17:12:06 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
54.247.188.179 - - [19/Dec/2013:17:12:22 +0000] "HEAD / HTTP/1.0" 200 0 "-" "NewRelicPinger/1.0 (370512)"
173.163.247.65 - - [20/Dec/2013:14:51:26 +0000] "GET /alive.txt HTTP/1.1" 200 6 "-" "-"
  LOG_SNIPPET

  let(:db) { SQLite3::Database.new "tmp/test.db" }

  let!(:importer) { Logripper::Importer.new(log_pseudofile) }

  describe '#import' do
    before do
      importer.import
    end

    it "should import all the records" do
      sql = "SELECT COUNT(*) FROM log_entries"
      db.get_first_value(sql).should == 4
    end

    it "should include the data from the log" do
      sql = "SELECT ip_address FROM log_entries"
      db.execute(sql).map(&:first).should == %w(64.49.91.30 173.163.247.62 54.247.188.179 173.163.247.65)
    end

    it "should import the timestamps" do
      sql = "SELECT datetime(timestamp, 'unixepoch') FROM log_entries"
      db.execute(sql).map(&:first).should == [
        "2013-12-19 17:12:02",
        "2013-12-19 17:12:06",
        "2013-12-19 17:12:22",
        "2013-12-20 14:51:26"
      ]
    end
  end

  describe 'import with existing records' do
    before do
      db.execute <<-SQL, Time.new(2013, 12, 20, 0, 0, 0).to_i
        INSERT INTO log_entries VALUES ("127.0.0.1", ?, "GET", "/", 200, 0, NULL, NULL)
      SQL
      importer.import
    end

    it "should import only newer records" do
      sql = "SELECT COUNT(*) FROM log_entries"
      db.get_first_value(sql).should == 2
    end
  end
end
