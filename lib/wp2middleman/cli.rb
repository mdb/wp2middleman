require 'thor'

module WP2Middleman
  class CLI < Thor
    default_task :wp2mm

    desc "WORDPRESS XML EXPORT FILE", "Migrate Wordpress posts to Middleman-style markdown files"
    option :body_to_markdown, :type => :boolean
    option :include_fields, :type => :array

    def wp2mm(wp_xml_export = nil)
      return usage unless wp_xml_export

      unless File.file? wp_xml_export
        error "#{wp_xml_export} is not a valid file"
        exit 1
      end

      include_fields = options[:include_fields] || []
      WP2Middleman.migrate(wp_xml_export, options[:body_to_markdown], include_fields)

      say "Successfully migrated #{wp_xml_export}", "\033[32m"
    end

    desc "usage", "Display usage banner", hide: true
    def usage
      say "wp2middleman #{WP2Middleman::VERSION}"
      say "https://github.com/mdb/wp2middleman"
      say "\n"

      help
    end
  end
end
