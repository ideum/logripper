require 'thor'
require 'logripper'

module Logripper
  class CLI < Thor
    QUERIES = %w[total_downloads daily_downloads vc_views vc_downloads]

    package_name 'logripper'

    desc "import LOG", "reads log into local database"
    def import(log)
      log_file = File.open(log, 'r')
      Importer.new(log_file).import
    end

    QUERIES.each do |query|
      desc query, "exports a report of the #{query}"
      option :google_username, required: true
      option :google_password, required: true
      define_method(query) do
        queries = Queries.new(Importer.new(nil).db)
        exporter = Exporter.new(queries.send(query))
        exporter.to_google_drive(
          query,
          google_username: options[:google_username],
          google_password: options[:google_password]
        )
      end
    end
  end
end
