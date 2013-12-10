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
      migrator.should_receive(:write_file).exactly(3).times
      migrator.migrate
    end
  end

  # pending
  describe "#write_file" do
  end

  describe "#file_content" do
    it "properly formats a post as a Middleman-style post" do
      expect(migrator.file_content(migrator.posts[1])).to eq("---\ntitle: A second title\ndate: 2011-07-25\ntags: some_tag, another tag, tag\n---\n\n <strong>Foo</strong>")
    end
  end

  describe "#full_filename" do
    it "returns the full filename for a Middleman-style markdown post" do
      expect(migrator.full_filename(migrator.posts[0])).to eq("#{Dir.pwd}/export/2012-06-08-A-Title.html.markdown.html.markdown")
    end
  end

  describe "#valid_post_data" do
    context "the post's #post_date, #title, #date_published, and #content are not nil" do
      let(:post) {
        double('Post',
          :post_date => 'post_date',
          :title => 'title',
          :date_published => 'date_published',
          :content => 'content'
        )
      }

      it "returns true" do
        expect(migrator.valid_post_data(post)).to eq(true)
      end
    end

    context "the post's #post_date, #title, #date_published, or #content is nil" do
      let(:post) {
        double('Post',
          :post_date => nil,
          :title => 'title',
          :date_published => 'date_published',
          :content => 'content'
        )
      }

      it "returns false" do
        expect(migrator.valid_post_data(post)).to eq(false)
      end
    end
  end

  describe "#output_path" do
    subject { migrator.output_path }

    it { should eq("#{Dir.pwd}/export/") }
  end

  # pending
  describe "#ensure_output_directory" do
  end
end
