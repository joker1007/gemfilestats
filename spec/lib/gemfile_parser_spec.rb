require 'spec_helper'

describe GemfileParser do
  let(:content) { "source 'https://rubygems.org'\nsource 'https://rubygems2.org'\ngroup :test do\n  gem \"guard-spork\"\n  gem \"guard-rspec\"\n  gem \"guard-cucumber\"\n  gem \"turn\", :require => false\nend\ngem \"rails3-generators\", :group => [:development]" }
  let(:gemline) { "gem \"rails3-generators\", :group => [:development]" }
  let(:group_block) { "group :test do\n  gem \"guard-spork\"\n  gem \"guard-rspec\"\n  gem \"guard-cucumber\"\n  gem \"turn\", :require => false\nend" }
  let(:str) { "\"test\"" }
  let(:sym) { ":test" }
  let(:array) { "[\"a\", \"b\", \"c\"]" }
  let(:hash) { "{:key1 => \"value1\", :key2 => {:key3 => \"value2\"}}" }

  describe ".parse" do
    it { GemfileParser.parse(str).should eq("test") }
    it { GemfileParser.parse(sym).should eq(:test) }
    it { GemfileParser.parse(array).should eq(["a", "b", "c"]) }
    it { GemfileParser.parse(hash).should eq({:key1 => "value1", :key2 => {:key3 => "value2"}}) }
    it { GemfileParser.parse(gemline).should eq({:type => :gem, :name => "rails3-generators", :version => nil, :group => [:development]}) }
    it { GemfileParser.parse(group_block).should eq([
      {:type => :gem, :name => "guard-spork", :version => nil, :group => [:test]},
      {:type => :gem, :name => "guard-rspec", :version => nil, :group => [:test]},
      {:type => :gem, :name => "guard-cucumber", :version => nil, :group => [:test]},
      {:type => :gem, :name => "turn", :version => nil, :group => [:test], :require => nil},
    ]) }
    it {GemfileParser.parse(content).should eq([
      {:type => :source, :url => "https://rubygems.org"},
      {:type => :source, :url => "https://rubygems2.org"},
      {:type => :gem, :name => "guard-spork", :version => nil, :group => [:test]},
      {:type => :gem, :name => "guard-rspec", :version => nil, :group => [:test]},
      {:type => :gem, :name => "guard-cucumber", :version => nil, :group => [:test]},
      {:type => :gem, :name => "turn", :version => nil, :group => [:test], :require => nil},
      {:type => :gem, :name => "rails3-generators", :version => nil, :group => [:development]},
    ])}
  end
end
