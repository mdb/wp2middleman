module WP2Middleman
  class Migrator
    def initialize(wp_xml_export_file)
      @posts = WP2Middleman::PostCollection.new(wp_xml_export_file).posts
    end

    def migrate
      ensure_export_directory

      @posts.each do |post|
        write_file(post)
      end
    end

    private

    def write_file(post)
      if valid_post_data(post)
        File.open(full_filename(post), "w") do |file|
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
      file_content += post.content
    end

    def full_filename(post)
      "#{output_path}#{post.created_at}-#{post.filename}.html.markdown"
    end

    def valid_post_data(post)
      !(post.created_at.nil? || post.title.nil? || post.date_published.nil? || post.content.nil?)
    end

    def output_path
      "#{ENV['PWD']}/export/"
    end

    def ensure_export_directory
      unless File.directory? output_path
        FileUtils.mkdir_p output_path
      end
    end
  end
end
