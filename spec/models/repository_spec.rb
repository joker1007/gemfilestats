require 'spec_helper'

describe Repository do
  it { should have_field(:url).of_type(String).with_default_value_of(false) }
  it { should have_field(:username).of_type(String).with_default_value_of(false) }
  it { should have_field(:name).of_type(String).with_default_value_of(false) }
  it { should embed_one(:gemfile) }
  it { should have_many(:used_gems) }

  it { should validate_presence_of(:url) }
  it { should validate_uniqueness_of(:url) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:name) }
  it { should validate_format_of(:url).to_allow("http://github.com/hogeuser/hogerepo").not_to_allow("http://other.com/hogeuser/hogerepo") }

  it { should be_timestamped_document }

  context "when saved" do
    subject {
      Repository.create!(:url => "http://github.com/hogeuser/hogerepo")
    }

    it "should get user and repository name from url" do
      subject.username.should eq("hogeuser")
      subject.name.should eq("hogerepo")
    end
  end

  describe "#get_gemfile" do
    subject { FactoryGirl.create(:repository) }
    before do
      GithubUtil.stub(:get_gemfile_body).and_return(File.read(File.join(Rails.root, "Gemfile")))
    end

    it "should get Gemfile blob" do
      subject.get_gemfile
      subject.gemfile.should_not be_nil
    end
  end

  describe "#async_get_gemfile_and_used_gems" do
    subject { FactoryGirl.build(:repository) }

    it "should receive Resque.enqueue(Job::GetUsedGemsJob, {repository's id})" do
      Resque.should_receive(:enqueue).with(Job::GetUsedGemsJob, subject.id)
      subject.async_get_gemfile_and_used_gems
    end
  end

  describe ".recent(n)" do
    before do
      FactoryGirl.create_list(:repository_seq, 10)
    end

    it "should return recent created n records" do
      Repository.recent(5).map{|repo| repo.name}.should eq(%w{repo10 repo9 repo8 repo7 repo6})
    end
  end
end
