require 'yaml'

module WP2Middleman
  class Frontmatter
    def initialize(post, include_fields: [])
      @post = post
      @include_fields = include_fields
    end

    def post_data
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

    def to_yaml
      post_data.to_yaml.strip
    end

    private

    attr_reader :post, :include_fields
  end
end