require 'spec_helper'

describe WP2Middleman::Post do
  let(:file) { Nokogiri::XML(File.open("#{ENV['PWD']}/spec/fixtures/fixture.xml")) }
  let(:post_one) { WP2Middleman::Post.new(file.css('item')[0]) }
  let(:post_two) { WP2Middleman::Post.new(file.css('item')[1]) }
  let(:post_three) { WP2Middleman::Post.new(file.css('item')[2]) }

  it "exists as a class within the WP2Middleman module" do
    WP2Middleman::Post.class.should eq Class
  end

  describe "#title" do
    subject { post_one.title }

    it { should eq "A Title" }
  end

  describe "#title_for_filename" do
    subject { post_one.title_for_filename }

    it { should eq "A-Title" }
  end

  describe "#filename" do
    subject { post_one.filename }

    it { should eq "2012-06-08-A-Title" }

    context "post titles with odd characters such as colons" do
      subject { post_three.filename }

      it { should eq "2011-07-26-A-third-title-With-colon" }
    end
  end

  describe "#post_date" do
    subject { post_one.post_date }

    it { should eq "2012-06-08 03:21:41" }
  end

  describe "#date_published" do
    subject { post_one.date_published }

    it { should eq "2012-06-08" }
  end

  describe "#status" do
    subject { post_three.status }

    it { should eq "private" }
  end

  describe "#field" do
    subject { post_one.field('wp:post_id') }

    it { should eq "84" }
  end

  describe "#published?" do
    subject { post_one.published? }

    it { should eq true }

    context "#status is not 'publish'" do
      subject { post_three.published? }

      it { should eq false }

    end
  end

  describe "#content" do
    subject { post_one.content }

    it { should eq "Paragraph one.\n\n      Paragraph two.\n    " }
  end

  describe "#markdown_content" do
    subject { post_two.markdown_content }

    it { should eq "**Foo**" }
  end

  describe "#tags" do
    subject { post_two.tags }

    it { should eq ["some_tag", "another tag", "tag"] }

    context "the post only has an 'Uncategorized' tag" do
      subject { post_one.tags }

      it { should eq [] }
    end
  end

  describe "#valid?" do
    def post(post_date: Date.new(2014,2,19), title: "Title", date_published: Date.new(2014,2,19), content: "content")
      post = WP2Middleman::Post.new(double)

      post.stub(:post_date).and_return(post_date)
      post.stub(:title).and_return(title)
      post.stub(:date_published).and_return(date_published)
      post.stub(:content).and_return(content)

      post
    end

    it "is valid with post_date, title, date_published, and content" do
      expect(post).to be_valid
    end

    it "is not valid without post_date" do
      expect(post(post_date: nil)).to_not be_valid
    end

    it "is not valid without a title" do
      expect(post(title: nil)).to_not be_valid
    end

    it "is not valid without a date_published" do
      expect(post(date_published: nil)).to_not be_valid
    end

    it "is not valid without content" do
      expect(post(content: nil)).to_not be_valid
    end
  end
end
