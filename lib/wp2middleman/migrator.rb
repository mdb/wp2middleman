require 'yaml'

module WP2Middleman
  class Migrator

    attr_reader :posts

    def initialize(wp_xml_export_file, body_to_markdown: false, include_fields: [])
      @body_to_markdown = body_to_markdown
      @include_fields = include_fields
      @posts = WP2Middleman::PostCollection.new(wp_xml_export_file).posts
    end

    def migrate
      ensure_export_directory

      @posts.each do |post|
        write_file(post)
      end
    end

    def write_file(post)
      if valid_post_data(post)
        File.write(full_filename(post), file_content(post))
      end
    end

    def file_content(post)
      yaml = frontmatter(post).to_yaml.strip

      <<-EOS.gsub(/^ {8}/, '')
        #{yaml}
        ---

        #{formatted_post_content(post)}
      EOS
    end

    def frontmatter(post)
      data = {
        'title' => post.title,
        'date' => post.date_published,
        'tags' => post.tags
      }

      data['published'] = false if !post.published?

      @include_fields.each do |field|
        data[field] = post.field(field)
      end

      data
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

    def valid_post_data(post)
      !(post.post_date.nil? || post.title.nil? || post.date_published.nil? || post.content.nil?)
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
