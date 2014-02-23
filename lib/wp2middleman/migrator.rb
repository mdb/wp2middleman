require 'yaml'

module WP2Middleman
  class Migrator
    attr_reader :posts

    def initialize(wp_xml_export_file, body_to_markdown: false, include_fields: [])
      @posts = WP2Middleman::PostCollection.from_file(
        wp_xml_export_file, 
        body_to_markdown: body_to_markdown, 
        include_fields: include_fields
      ).without_attachments.only_valid
    end

    def migrate
      ensure_export_directory

      posts.each do |post|
        File.write(post.full_filename(output_path), post.file_content)
      end
    end

    def output_path
      "#{Dir.pwd}/export/"
    end

    def ensure_export_directory
      unless File.directory? output_path
        FileUtils.mkdir_p output_path
      end
    end
  end
end
