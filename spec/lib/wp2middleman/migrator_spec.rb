require 'spec_helper'

describe WP2Middleman::Migrator do
  let(:file) { 'spec/fixtures/fixture.xml' }
  let(:migrator) { WP2Middleman::Migrator.new(file) }

  it "exists as a class within the WP2Middleman module" do
    WP2Middleman::Migrator.class.should eq Class
  end

  describe "#migrate" do

    before :each do
      migrator.stub :ensure_export_directory
      migrator.stub :write_file
    end

    it "ensures there is an export directory" do
      migrator.should_receive :ensure_export_directory
      migrator.migrate
    end

    it "writes a middleman markdown file for each post" do
      migrator.should_receive(:write_file).exactly(122).times
      migrator.migrate
    end
  end
end
