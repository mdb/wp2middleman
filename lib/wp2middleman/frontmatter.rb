puts "loading"

module WP2Middleman
  class Frontmatter
    def initialize post
      @post = post
    end

    def data include_fields=[]
      data = {
        'title' => post.title,
        'date' => post.date_published,
        'tags' => post.tags
      }

      data['published'] = false if !post.published?

      include_fields.each do |field|
        data[field] = post.field(field)
      end

      data
    end

    private

    attr_reader :post
  end
end