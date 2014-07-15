require 'spec_helper'

describe WP2Middleman::Migrator do
  def post(attributes = {})
    defaults = {title: "mytitle", date_published: "mydate", tags: "mytags", published?: false}
    @post ||= double(defaults.merge attributes)
  end

  it "includes the title, date, and tags from the post" do
    frontmatter = WP2Middleman::Frontmatter.new(post).post_data

    expect(frontmatter["title"]).to eq("mytitle")
    expect(frontmatter["date"]).to eq("mydate")
    expect(frontmatter["tags"]).to eq("mytags")
  end

  it "sets published to false for unpublished posts" do
    frontmatter = WP2Middleman::Frontmatter.new(post).post_data

    expect(frontmatter["published"]).to be_falsey
  end

  it "sets published to nil for published posts" do
    frontmatter = WP2Middleman::Frontmatter.new(post published?: true).post_data

    expect(frontmatter["published"]).to be_nil
  end

  it "includes fields specified in include_fields" do
    allow(post).to receive(:field).with("field1") { "value1" }
    allow(post).to receive(:field).with("field2") { "value2" }

    frontmatter = WP2Middleman::Frontmatter.new(post, include_fields: ["field1", "field2"]).post_data
    
    expect(frontmatter["field1"]).to eq("value1")
    expect(frontmatter["field2"]).to eq("value2")
  end
end
