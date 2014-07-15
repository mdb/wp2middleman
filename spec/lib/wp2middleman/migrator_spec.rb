require 'spec_helper'

describe WP2Middleman::Migrator do
  let(:file) { 'spec/fixtures/fixture.xml' }
  let(:migrator) { WP2Middleman::Migrator.new(file) }

  it "exists as a class within the WP2Middleman module" do
    expect(WP2Middleman::Migrator.class).to eq Class
  end

  describe "#migrate" do
    before :each do
      FileUtils.stub :mkdir_p
      File.stub :write
    end

    it "ensures there is an export directory" do
      File.stub :open
      expect(migrator).to receive :ensure_export_directory
      migrator.migrate
    end

    it "writes a middleman markdown file for each post" do
      expect(File).to receive(:write).exactly(4).times
      migrator.migrate
    end
 
    it "writes the proper markdown file" do
      post = migrator.posts.first
      post.stub(:file_content).and_return("content")
      migrator.stub(:valid_posts).and_return([post])

      expect(File).to receive(:write).with("#{Dir.pwd}/export/2012-06-08-A-Title.html.markdown", "content")
      migrator.migrate
    end
  end

  describe "#output_path" do
    subject { migrator.output_path }
    let(:export_path) { migrator.output_path }

    it "reports the proper path to the export directory" do
      expect(export_path).to eq "#{Dir.pwd}/export/"
    end
  end

  describe "#ensure_export_directory" do
    it "makes the export directory if it's not already there" do
      File.stub(:directory?).and_return false

      expect(FileUtils).to receive(:mkdir_p).with("#{Dir.pwd}/export/")

      migrator.ensure_export_directory
    end

    context "the export directory is already there" do
      it "does not create it" do
        File.stub(:directory?).and_return true

        migrator.ensure_export_directory

        expect(FileUtils).not_to receive(:mkdir_p).with("#{Dir.pwd}/export/")
      end
    end
  end
end
