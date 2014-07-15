require 'spec_helper'

describe WP2Middleman do
  it "exists as a module" do
    expect(WP2Middleman.class).to eq Module
  end

  describe ".migrate" do
    before :each do
      @migrator_double = double(WP2Middleman::Migrator)
    end

    it "migrates the posts in the wordpress XML export file it's passed" do
      expect(WP2Middleman::Migrator).to receive(:new).with('foo', body_to_markdown: false, include_fields: []).and_return(@migrator_double)
      expect(@migrator_double).to receive(:migrate)

      WP2Middleman.migrate 'foo'
    end
  end
end
