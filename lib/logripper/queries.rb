module Logripper
  class Queries
    def initialize(db)
      @db = db
    end

    def total_downloads
      @db.execute2 <<-SQL
        SELECT count(*) as count
        FROM log_entries
        WHERE url LIKE '/system/installers/GestureWorksGameplaySetup_%'
      SQL
    end

    def downloads_by_day
      @db.execute2 <<-SQL
        SELECT date(timestamp, 'unixepoch') as day, count(*) as count
        FROM log_entries
        WHERE url LIKE '/system/installers/GestureWorksGameplaySetup_%'
        GROUP BY day;
      SQL
    end

    def vc_downloads
      @db.execute2 <<-SQL
        SELECT url, count(*) as count
        FROM log_entries
        WHERE url LIKE '%/file.xml'
        GROUP BY url;
      SQL
    end
  end
end
