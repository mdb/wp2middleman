module WP2Middleman
  class MiddlemanPost
    def initialize(wp_post, body_to_markdown: false, include_fields: [])
      @wp_post = wp_post
      @body_to_markdown = body_to_markdown
      @include_fields = include_fields
    end

    def title
      wp_post.title
    end

    def title_for_filename
      title.gsub(/[^\w\s_-]+/, '')
        .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
        .gsub(/\s+/, '-')
    end

    def filename
      "#{date_published}-#{title_for_filename}"
    end

    def date_published
      wp_post.date_published
    end

    def full_filename output_path
      "#{output_path}#{filename}.html.markdown"
    end

    def file_content
      <<-EOS.gsub(/^ {8}/, '')
        #{frontmatter.to_yaml}
        ---

        #{formatted_post_content}
      EOS
    end

    def formatted_post_content
      if body_to_markdown
        markdown_content
      else
        content
      end
    end

    def content
      wp_post.content
    end

    def markdown_content
      html = HTMLPage.new :contents => content
      html.comment do |node,_|
        "#{node}"
      end
      html.iframe do |node,_|
        "#{node}"
      end
      html.markdown
    end

    private

    attr_reader :wp_post, :body_to_markdown, :include_fields

    def frontmatter
      @frontmatter ||= Frontmatter.new(wp_post, include_fields: include_fields)
    end
  end
end
