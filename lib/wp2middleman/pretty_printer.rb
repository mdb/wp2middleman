module WP2Middleman
  class PrettyPrinter
    def initialize(html)
      @html = html
    end

    def print
      #@html.to_xhtml(indent: 2)
      Nokogiri::XML(@html, &:noblanks).to_xhtml(indent: 2)
    end

    private

    def xsl_file
      File.expand_path(File.join(File.dirname(__FILE__), "pretty_print.xsl"))
    end
  end
end
