require 'nokogiri'

module WP2Middleman
  class PostCollection
    include Enumerable

    def self.from_file(wp_xml_export_file) 
      xml = Nokogiri::XML(File.open("#{Dir.pwd}/#{wp_xml_export_file}"))
      new xml.css('item').collect { |wp_post| WP2Middleman::Post.new(wp_post) }
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

    private

    attr_reader :posts
  end
end
