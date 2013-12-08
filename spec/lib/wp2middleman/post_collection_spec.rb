require 'spec_helper'

describe WP2Middleman::PostCollection do
  let(:file) { 'spec/fixtures/fixture.xml' }
  let(:posts) { WP2Middleman::PostCollection.new(file).posts }

  it "exists as a class within the WP2Middleman module" do
    WP2Middleman::PostCollection.class.should eq Class
  end

  describe "#title" do
    it "returns an array of posts" do
      posts.class.should eq Array
    end
  end
end
