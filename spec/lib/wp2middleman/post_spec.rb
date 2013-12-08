require 'spec_helper'

describe WP2Middleman::Post do
  let(:file) { Nokogiri::XML(File.open("#{ENV['PWD']}/spec/fixtures/fixture.xml")) }
  let(:post) { WP2Middleman::Post.new(file) }

  it "exists as a class within the WP2Middleman module" do
    WP2Middleman::Post.class.should eq Class
  end

  describe "#title" do
    it "returns an array of posts" do
      posts.class.should eq Array
    end
  end
end
