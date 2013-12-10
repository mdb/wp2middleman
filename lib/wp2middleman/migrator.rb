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
        File.open("#{output_path}#{post.filename}", "w") do |file|
          file.write(file_content(post))
        end
      end
    end

    def file_content(post)
      file_content = "---\n"
      file_content += "title: #{post.title}\n"
      file_content += "date: #{post.date_published}\n"
      file_content += "tags: #{post.tags.join(', ')}\n"
      file_content += "---\n\n"
      file_content += formatted_post_content(post)

      file_content
    end

    def formatted_post_content(post)
      if @body_to_markdown == true
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
