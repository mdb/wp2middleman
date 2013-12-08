require 'spec_helper'

describe WP2Middleman do
  it "exists as a module" do
    WP2Middleman.class.should eq Module
  end

  describe ".migrate" do
    before :each do
      @migrator_double = double(WP2Middleman::Migrator)
    end

    it "verifies environment variables and uploads the directory and its contents to the specified S3 bucket" do
      WP2Middleman::Migrator.should_receive(:new).with('foo').and_return(@migrator_double)
      @migrator_double.should_receive(:migrate)

      WP2Middleman.migrate 'foo'
    end
  end
end
