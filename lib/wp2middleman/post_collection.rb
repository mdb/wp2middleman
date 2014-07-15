require 'nokogiri'

module WP2Middleman
  class PostCollection
    include Enumerable

    def self.from_file(wp_xml_export_file)
      xml = Nokogiri::XML(File.open("#{Dir.pwd}/#{wp_xml_export_file}"))
      new xml.css('item').collect { |raw_wp_post| WP2Middleman::Post.new(raw_wp_post) }
    end

    def initialize(posts=[])
      @posts = posts
    end

    def each(&block)
      posts.each &block
    end

    def [] key
      posts[key]
    end

    def empty?
      posts.empty?
    end

    def without_attachments
      self.class.new(reject(&:attachment?))
    end

    def only_valid
      self.class.new(select(&:valid?))
    end

    def to_middleman(body_to_markdown: false, include_fields: [])
      middleman_posts = collect { |p| WP2Middleman::MiddlemanPost.new(p, body_to_markdown: body_to_markdown, include_fields: include_fields) }
      self.class.new(middleman_posts)
    end

    private

    attr_reader :posts
  end
end
