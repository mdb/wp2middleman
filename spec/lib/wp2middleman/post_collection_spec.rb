require 'spec_helper'

describe WP2Middleman::PostCollection do
  let(:file) { 'spec/fixtures/fixture.xml' }

  it "exists as a class within the WP2Middleman module" do
    expect(WP2Middleman::PostCollection.class).to eq Class
  end

  it "contains a Post object for every word press item" do
    posts = WP2Middleman::PostCollection.from_file(file)

    expect(posts).to_not be_empty

    posts.each do |post|
      expect(post).to be_a WP2Middleman::Post
    end
  end

  it "can reject attachments" do
    post = double :post, attachment?: false
    attachment = double :post, attachment?: true

    post_collection = WP2Middleman::PostCollection.new([post, attachment]).without_attachments

    expect(post_collection.to_a).to eq([post])
  end
end
