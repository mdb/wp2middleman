require 'spec_helper'

describe WP2Middleman do
  it "exists as a module" do
    WP2Middleman.class.should eq Module
  end

  describe ".migrate" do
    before :each do
      @migrator_double = double(WP2Middleman::Migrator)
    end

    it "migrates the posts in the wordpress XML export file it's passed" do
      WP2Middleman::Migrator.should_receive(:new).with('foo', body_to_markdown: false).and_return(@migrator_double)
      @migrator_double.should_receive(:migrate)

      WP2Middleman.migrate 'foo'
    end
  end
end
