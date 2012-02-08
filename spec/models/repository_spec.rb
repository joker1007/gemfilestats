require 'spec_helper'

describe Repository do
  it { should have_field(:url).of_type(String).with_default_value_of(false) }
  it { should have_field(:username).of_type(String).with_default_value_of(false) }
  it { should have_field(:name).of_type(String).with_default_value_of(false) }
  it { should embed_one(:gemfile) }

  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:name) }

  context "when saved" do
    subject {
      Repository.create!(:url => "http://github.com/hogeuser/hogerepo")
    }

    it "should get user and repository name from url" do
      subject.username.should eq("hogeuser")
      subject.name.should eq("hogerepo")
    end
  end
end
