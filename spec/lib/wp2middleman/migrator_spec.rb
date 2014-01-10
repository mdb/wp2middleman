require 'spec_helper'

describe WP2Middleman::Migrator do
  let(:file) { 'spec/fixtures/fixture.xml' }
  let(:migrator) { WP2Middleman::Migrator.new(file) }

  it "exists as a class within the WP2Middleman module" do
    WP2Middleman::Migrator.class.should eq Class
  end

  describe "#migrate" do

    before :each do
      FileUtils.stub :mkdir_p
      File.stub :write
    end

    it "ensures there is an export directory" do
      File.stub :open
      migrator.should_receive :ensure_export_directory
      migrator.migrate
    end

    it "writes a middleman markdown file for each post" do
      migrator.should_receive(:write_file).exactly(3).times
      migrator.migrate
    end
  end

  describe "#write_file" do
    before :each do
      @post = migrator.posts[0]
    end

    it "ensures that the post it's passed contains valid data" do
      migrator.should_receive(:valid_post_data).with(@post)
      migrator.write_file(@post)
    end

    it "writes the proper markdown file" do
      File.should_receive(:open).with( "#{Dir.pwd}/export/2012-06-08-A-Title.html.markdown", "w")
      migrator.write_file(@post)
    end

    # pending
    xit "writes the proper markdown file" do
      File.should_receive(:write).with(migrator.file_content(@post))
      migrator.write_file(@post)
    end
  end

  describe "#file_content" do
    it "properly formats a post as a Middleman-style post" do
      expect(migrator.file_content(migrator.posts[1])).to eq("---\ntitle: A second title\ndate: 2011-07-25\ntags: some_tag, another tag, tag\n---\n\n <strong>Foo</strong>")
    end

    context "its behavior if @body_to_markdown is true" do
      let(:migrator) { WP2Middleman::Migrator.new(file, body_to_markdown: true) }

      it "formats the post body as markdown" do
        expect(migrator.file_content(migrator.posts[1])).to eq("---\ntitle: A second title\ndate: 2011-07-25\ntags: some_tag, another tag, tag\n---\n\n**Foo**")
      end
    end

    context "the post is not published" do
      it "reports 'published: false' in the post's frontmatter" do
        expect(migrator.file_content(migrator.posts[2])).to eq("---\ntitle: 'A third title: With colon'\ndate: 2011-07-26\ntags: some_tag, another tag, tag\npublished: false\n---\n\nFoo")
      end
    end
  end

  describe "#formatted_frontmatter" do
    context "title has special characters" do
      let(:post) {
        double('Post',
          :post_date => 'post_date',
          :title => 'title, with, comma',
          :date_published => '2011-07-25',
          :tags => %w[some_tag another\ tag tag],
          :published? => true,
          :content => 'content'
        )
      }

      it "wraps the title in quotes" do
        expect(migrator.formatted_frontmatter(post)).to eq("title: 'title, with, comma'\ndate: 2011-07-25\ntags: some_tag, another tag, tag\n")
      end
    end

    context "title has no special characters" do
      let(:post) {
        double('Post',
          :post_date => 'post_date',
          :title => 'simple title',
          :date_published => '2011-07-25',
          :tags => %w[some_tag another\ tag tag],
          :published? => true,
          :content => 'content'
        )
      }

      it "does not wrap the title in quotes" do
        expect(migrator.formatted_frontmatter(post)).to eq("title: simple title\ndate: 2011-07-25\ntags: some_tag, another tag, tag\n")
      end
    end
  end

  describe "#formatted_post_content" do
    it "returns the content of the post it's passed" do
      expect(migrator.formatted_post_content(migrator.posts[1])).to eq(" <strong>Foo</strong>")
    end

    context "its behavior if @body_to_markdown is true" do
      let(:migrator) { WP2Middleman::Migrator.new(file, body_to_markdown: true) }

      it "returns the content of the post it's passed as markdown" do
        expect(migrator.formatted_post_content(migrator.posts[1])).to eq("**Foo**")
      end
    end
  end

  describe "#full_filename" do
    it "returns the full filename for a Middleman-style markdown post" do
      expect(migrator.full_filename(migrator.posts[0])).to eq("#{Dir.pwd}/export/2012-06-08-A-Title.html.markdown")
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

  describe "#ensure_export_directory" do
    it "makes the export directory if it's not already there" do
      File.stub(:directory?).and_return false

      FileUtils.should receive(:mkdir_p).with("#{Dir.pwd}/export/")

      migrator.ensure_export_directory
    end

    context "the export directory is already there" do
      it "does not create it" do
        File.stub(:directory?).and_return true

        migrator.ensure_export_directory

        FileUtils.should_not receive(:mkdir_p).with("#{Dir.pwd}/export/")
      end
    end
  end
end
