module WP2Middleman
  class Migrator

    attr_reader :posts

    def initialize(wp_xml_export_file, body_to_markdown: false)
      @body_to_markdown = body_to_markdown
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
        File.open(full_filename(post), "w") do |file|
          file.write(file_content(post))
        end
      end
    end

    def file_content(post)
      file_content = "---\n"
      file_content += formatted_frontmatter(post)
      file_content += "---\n\n"
      file_content += formatted_post_content(post)

      file_content
    end

    def format_string(string)
      # if the string has special characters, quote it
      if !string.match(/\A[[:alnum:] _]+\z/)
        "'#{string}'"
      else
        string
      end
    end

    def formatted_frontmatter(post)
      frontmatter = "title: #{format_string(post.title)}\n"
      frontmatter += "date: #{post.date_published}\n"
      frontmatter += "tags: #{post.tags.map{|t| format_string(t)}.join(', ')}\n"

      if !post.published?
        frontmatter += "published: false\n"
      end

      frontmatter
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
