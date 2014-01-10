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
      "#{date_published}-#{title_for_filename}"
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
