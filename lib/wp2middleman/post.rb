require 'html2markdown'

module WP2Middleman
  class Post
    attr_accessor :post

    def initialize(nokogiri_post_doc)
      @post = nokogiri_post_doc
    end

    def title
      post.css('title').text
    end

    def title_for_filename
      title.gsub(/[^\w\s_-]+/, '')
      .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
      .gsub(/\s+/, '-')
    end

    def valid?
      !(post_date.nil? || title.nil? || date_published.nil? || content.nil?)
    end

    def attachment?
      type == 'attachment'
    end

    def filename
      "#{date_published}-#{title_for_filename}"
    end

    def full_filename output_path
      "#{output_path}#{filename}.html.markdown"
    end

    def field(field)
      post.xpath(field).first.inner_text
    end

    def file_content(include_fields: [], body_to_markdown: false)
      frontmatter = Frontmatter.new(self, include_fields: include_fields)

      <<-EOS.gsub(/^ {8}/, '')
        #{frontmatter.to_yaml}
        ---

        #{formatted_post_content(body_to_markdown: body_to_markdown)}
      EOS
    end

    def formatted_post_content body_to_markdown: false
      if body_to_markdown
        markdown_content
      else
        content
      end
    end

    def post_date
      post.xpath("wp:post_date").first.inner_text
    end

    def date_published
      Date.parse(post_date).to_s
    end

    def status
      post.xpath("wp:status").first.inner_text
    end

    def type
      post.xpath("wp:post_type").first.inner_text
    end

    def published?
      status == 'publish'
    end

    def content
      post.at_xpath(".//content:encoded").inner_text
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

    def tags
      tags = []
      categories = post.xpath("category")

      categories.each do |category|
        tag_name = category.css("@nicename").text

        tags.push tag_name unless tag_name == 'uncategorized'
      end

      tags
    end
  end
end
