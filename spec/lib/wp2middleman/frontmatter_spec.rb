require 'spec_helper'

describe WP2Middleman::Migrator do
  it "exists as a class within the WP2Middleman module" do
    WP2Middleman::Frontmatter.class.should eq Class
  end

  def post(attributes = {})
    defaults = {title: "mytitle", date_published: "mydate", tags: "mytags", published?: false}
    @post ||= double(defaults.merge attributes)
  end

  it "includes the title, date, and tags from the post" do
    frontmatter = WP2Middleman::Frontmatter.new(post).data

    expect(frontmatter["title"]).to eq("mytitle")
    expect(frontmatter["date"]).to eq("mydate")
    expect(frontmatter["tags"]).to eq("mytags")
  end

  it "sets published to false for unpublished posts" do
    frontmatter = WP2Middleman::Frontmatter.new(post).data
    expect(frontmatter["published"]).to be_false
  end

  it "sets published to nil for published posts" do
    frontmatter = WP2Middleman::Frontmatter.new(post published?: true).data
    expect(frontmatter["published"]).to be_nil
  end

  it "includes fields specified in include_fields" do
    allow(post).to receive(:field).with("field1") { "value1" }
    allow(post).to receive(:field).with("field2") { "value2" }
    frontmatter = WP2Middleman::Frontmatter.new(post).data(["field1", "field2"])
    expect(frontmatter["field1"]).to eq("value1")
    expect(frontmatter["field2"]).to eq("value2")
  end
end