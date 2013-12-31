module Logripper
  class Queries
    def initialize(db)
      @db = db
    end

    def total_downloads
      @db.execute2 <<-SQL
        SELECT COUNT(DISTINCT(ip_address)) as count
        FROM log_entries
        WHERE url LIKE '/system/installers/GestureWorksGameplaySetup_%'
      SQL
    end

    def downloads_by_day
      @db.execute2 <<-SQL
        SELECT date(timestamp, 'unixepoch') as day, COUNT(DISTINCT(ip_address)) as count
        FROM log_entries
        WHERE url LIKE '/system/installers/GestureWorksGameplaySetup_%'
        GROUP BY day;
      SQL
    end

    def vc_views
      rows = @db.execute2 <<-SQL
        SELECT url, COUNT(DISTINCT(ip_address)) as count
        FROM log_entries
        WHERE url LIKE '/virtual_controllers/%'
        GROUP BY url;
      SQL
      headers = rows.shift
      data = rows.inject([]) do |res, row|
        res << row if row[0].match %r{^/virtual_controllers/[^/]+$}
        res
      end
      data.unshift headers
    end

    def vc_downloads
      @db.execute2 <<-SQL
        SELECT url, COUNT(DISTINCT(ip_address)) as count
        FROM log_entries
        WHERE url LIKE '/virtual_controllers/%/file.xml'
        GROUP BY url;
      SQL
    end
  end
end
