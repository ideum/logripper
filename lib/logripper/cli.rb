require 'thor'
require 'logripper'

module Logripper
  class CLI < Thor
    package_name 'logripper'

    desc "import LOG", "reads log into local database"
    def import(log)
      log_file = File.open(log, 'r')
      Importer.new(log_file).import
    end

    desc "total_downloads", "exports a total trial download count CSV"
    def total_downloads
      queries = Queries.new(Importer.new(nil).db)
      puts Exporter.new(queries.total_downloads).to_csv
    end

    desc "daily_downloads", "exports a daily trial download count CSV"
    def daily_downloads
      queries = Queries.new(Importer.new(nil).db)
      puts Exporter.new(queries.downloads_by_day).to_csv
    end

    desc "vc_views", "exports a vc view count CSV"
    def vc_views
      queries = Queries.new(Importer.new(nil).db)
      puts Exporter.new(queries.vc_views).to_csv
    end

    desc "vc_downloads", "exports a vc download count CSV"
    def vc_downloads
      queries = Queries.new(Importer.new(nil).db)
      puts Exporter.new(queries.vc_downloads).to_csv
    end
  end
end
