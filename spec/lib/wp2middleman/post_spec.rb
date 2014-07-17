require 'spec_helper'

describe WP2Middleman::Post do
  let(:file) { Nokogiri::XML(File.open("#{ENV['PWD']}/spec/fixtures/fixture.xml")) }
  let(:post_one) { WP2Middleman::Post.new(file.css('item')[0]) }
  let(:post_two) { WP2Middleman::Post.new(file.css('item')[1]) }
  let(:post_three) { WP2Middleman::Post.new(file.css('item')[2]) }

  it "exists as a class within the WP2Middleman module" do
    expect(WP2Middleman::Post.class).to eq Class
  end

  describe "#title" do
    subject { post_one.title }

    it { is_expected.to eq "A Title" }
  end

  describe "#post_date" do
    subject { post_one.post_date }

    it { is_expected.to eq "2012-06-08 03:21:41" }
  end

  describe "#date_published" do
    subject { post_one.date_published }

    it { is_expected.to eq "2012-06-08" }
  end

  describe "#status" do
    subject { post_three.status }

    it { is_expected.to eq "private" }
  end

  describe "#field" do
    subject { post_one.field('wp:post_id') }

    it { is_expected.to eq "84" }
  end

  describe "#published?" do
    subject { post_one.published? }

    it { is_expected.to eq true }

    context "#status is not 'publish'" do
      subject { post_three.published? }

      it { is_expected.to eq false }

    end
  end

  describe "#content" do
    subject { post_one.content }

    it { is_expected.to eq "Paragraph one.\n\n      Paragraph two.\n    " }
  end

  describe "#tags" do
    subject { post_two.tags }

    it { is_expected.to eq ["some_tag", "another tag", "tag"] }

    context "the post only has an 'Uncategorized' tag" do
      subject { post_one.tags }

      it { is_expected.to eq [] }
    end
  end

  describe "#valid?" do
    def post(post_date: Date.new(2014,2,19), title: "Title", date_published: Date.new(2014,2,19), content: "content")
      post = WP2Middleman::Post.new(double)

      allow(post).to receive(:post_date) { post_date }
      allow(post).to receive(:title) { title }
      allow(post).to receive(:date_published) { date_published }
      allow(post).to receive(:content) { content }

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
