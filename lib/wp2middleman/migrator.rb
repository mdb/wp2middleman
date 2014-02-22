require 'yaml'

module WP2Middleman
  class Migrator

    attr_reader :posts

    def initialize(wp_xml_export_file, body_to_markdown: false, include_fields: [])
      @body_to_markdown = body_to_markdown
      @include_fields = include_fields
      @posts = WP2Middleman::PostCollection.from_file(wp_xml_export_file).without_attachments.only_valid
    end

    def migrate
      ensure_export_directory

      posts.each do |post|
        File.write(full_filename(post), file_content(post))
      end
    end

    def file_content(post, include_fields: @include_fields)
      frontmatter = Frontmatter.new(post, include_fields: include_fields)

      <<-EOS.gsub(/^ {8}/, '')
        #{frontmatter.to_yaml}
        ---

        #{formatted_post_content(post)}
      EOS
    end

    def formatted_post_content(post)
      if @body_to_markdown
        post.markdown_content
      else
        post.content
      end
    end

    def full_filename(post)
      "#{output_path}#{post.filename}.html.markdown"
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
