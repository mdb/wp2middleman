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
      migrator.should_receive(:write_file).exactly(4).times
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
      expect(migrator.file_content(migrator.posts[1])).to eq("---\ntitle: A second title\ndate: '2011-07-25'\ntags:\n- some_tag\n- another tag\n- tag\n---\n\n <strong>Foo</strong>\n")
    end

    context "its behavior if @body_to_markdown is true" do
      let(:migrator) { WP2Middleman::Migrator.new(file, body_to_markdown: true) }

      it "formats the post body as markdown" do
        expect(migrator.file_content(migrator.posts[1])).to eq("---\ntitle: A second title\ndate: '2011-07-25'\ntags:\n- some_tag\n- another tag\n- tag\n---\n\n**Foo**\n")
      end

      it "includes iframe and comment" do
        expect(migrator.file_content(migrator.posts[3])).to eq("---\ntitle: A fourth item with iframe and comment\ndate: '2011-07-26'\ntags:\n- some_tag\n- another tag\n- tag\npublished: false\n---\n\nHere's a post with an iframe and a comment.\n\n\n<!--more-->\n\n\n<iframe width=\"400\" height=\"100\" style=\"position: relative; display: block; width: 400px; height: 100px;\" src=\"http://bandcamp.com/EmbeddedPlayer/v=2/track=833121761/size=venti/bgcol=FFFFFF/linkcol=4285BB/\" allowtransparency=\"true\" frameborder=\"0\"><a href=\"http://dihannmoore.bandcamp.com/track/you-do-it-for-me\">\"YOU DO IT FOR ME\" by DIHANN MOORE</a></iframe>\n")
      end
    end

    context "has been passed include_fields" do
      let(:migrator) { WP2Middleman::Migrator.new(file, include_fields: ['wp:post_id']) }

      it "includes the property and value from the item's xml in the frontmatter" do
        expect(migrator.file_content(migrator.posts[1])).to eq("---\ntitle: A second title\ndate: '2011-07-25'\ntags:\n- some_tag\n- another tag\n- tag\nwp:post_id: '209'\n---\n\n <strong>Foo</strong>\n")
      end

    end

    context "the post is not published" do
      it "reports 'published: false' in the post's frontmatter" do
        expect(migrator.file_content(migrator.posts[2])).to eq("---\ntitle: 'A third title: With colon'\ndate: '2011-07-26'\ntags:\n- some_tag\n- another tag\n- tag\npublished: false\n---\n\nFoo\n")
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
