require 'nokogiri'

module WP2Middleman
  class PostCollection
    def initialize(wp_xml_export_file)
      @xml = Nokogiri::XML(File.open("#{Dir.pwd}/#{wp_xml_export_file}"))
    end

    def posts
      @xml.css('item').map { |post| WP2Middleman::Post.new(post) }
    end
  end
end
