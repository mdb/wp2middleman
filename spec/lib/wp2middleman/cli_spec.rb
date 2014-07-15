require 'spec_helper'

describe WP2Middleman::CLI do

  subject { cli }
  let(:cli) { described_class.new }

  describe "#wp2mm" do
    before do
      cli.stub :say
    end

    context "it's not passed any arguments" do
      it "returns usage details" do
        expect(cli).to receive(:usage).exactly(1).times
        cli.wp2mm
      end
    end

    context "it's passed a Wordpress XML export file that does not exist" do
      it "reports that it was passed an invalid directory and exits with an exit code of 1" do
        Kernel.stub(:exit).and_return true
        File.stub(:file?).and_return false
        expect(cli).to receive(:error).with("foo is not a valid file")
        lambda { cli.wp2mm 'foo' }.should exit_with_code(1)
      end
    end

    context "it's passed a valid Wordpress XML export file" do
      before :each do
        WP2Middleman.stub(:migrate).and_return false
        File.stub(:file?).and_return true
      end

      it "migrates the posts listed in the XML file" do
        expect(WP2Middleman).to receive(:migrate).with "foo", nil, []
        cli.wp2mm "foo"
      end

      it "reports that the directory has been successfully uploaded" do
        expect(cli).to receive(:say).with("Successfully migrated foo", "\e[32m")
        cli.wp2mm "foo"
      end
    end

    context "sets include_fields" do
      before :each do
        WP2Middleman.stub(:migrate).and_return false
        File.stub(:file?).and_return true
      end

      it "deserializes the values into an array" do
        expect(WP2Middleman).to receive(:migrate).with "foo", nil, ['wp:post_id', 'guid']

        capture :stdout do
          WP2Middleman::CLI.start %w[wp2mm foo --include_fields=wp:post_id guid]
        end
      end
    end
  end

  describe "#usage" do
    subject(:usage) { cli.usage }

    it "displays version info, GitHub info, and help" do
      expect(cli).to receive(:say).with('wp2middleman 0.0.1')
      expect(cli).to receive(:say).with('https://github.com/mdb/wp2middleman')
      expect(cli).to receive(:say).with("\n")
      expect(cli).to receive(:help)

      usage
    end
  end
end
