require 'spec_helper'

describe WP2Middleman::CLI do

  subject { cli }
  let(:cli) { described_class.new }

  describe "#wp2mm" do
    context "it's not passed any arguments" do
      it "returns usage details" do
        cli.should_receive(:usage).exactly(1).times
        cli.wp2mm
      end
    end

    context "it's passed a Wordpress XML export file that does not exist" do
      it "reports that it was passed an invalid directory and exits with an exit code of 1" do
        Kernel.stub(:exit).and_return true
        File.stub(:file?).and_return false
        cli.should_receive(:error).with("foo is not a valid file")
        lambda { cli.wp2mm 'foo' }.should exit_with_code(1)
      end
    end

    context "it's passed a valid Wordpress XML export file" do
      before :each do
        WP2Middleman.stub(:migrate).and_return false
        File.stub(:file?).and_return true
      end

      it "migrates the posts listed in the XML file" do
        WP2Middleman.should_receive(:migrate).with "foo"
        cli.wp2mm "foo"
      end

      it "reports that the directory has been successfully uploaded" do
        cli.should_receive(:say).with("Successfully migrated foo", "\e[32m")
        cli.wp2mm "foo"
      end
    end
  end

  describe "#usage" do
    subject(:usage) { cli.usage }

    it "displays version info, GitHub info, and help" do
      cli.should_receive(:say).with('wp2middleman 0.0.1')
      cli.should_receive(:say).with('https://github.com/mdb/wp2middleman')
      cli.should_receive(:say).with("\n")
      cli.should_receive(:help)

      usage
    end
  end
end
