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

    def filename
      "#{date_published}-#{title_for_filename}.html.markdown"
    end

    def post_date
      post.xpath("wp:post_date").first.inner_text
    end

    def date_published
      Date.parse(post_date).to_s
    end

    def content
      post.at_xpath(".//content:encoded").inner_text
    end

    def sanitized_content
      clean_content = content

      clean_content.gsub!("<encoded>", " ")
      clean_content.gsub!("</encoded>", " ")
      clean_content.gsub!("&gt;", " ")
      clean_content.gsub("<![CDATA[", " ")
      clean_content.gsub!("]];", " ")
      clean_content.gsub!("]]>;", " ")

      clean_content
    end

    def markdown_content
      html = HTMLPage.new :contents => content

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
