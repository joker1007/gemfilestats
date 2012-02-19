require 'spec_helper'

describe UsedGem do
  it { should have_field(:name).of_type(String) }
  it { should have_field(:url).of_type(String) }
  it { should have_field(:version).of_type(String) }
  it { should have_field(:group).of_type(Array) }
  it { should have_field(:author).of_type(String) }
  it { should be_referenced_in(:repository) }
  it { should be_timestamped_document }
  it { should validate_presence_of(:name) }

  context "When saved" do
    subject { FactoryGirl.build(:used_gem) }
    before do
      subject.save
    end

    its(:url) {should eq("http://rubygems.org/gems/rails")}
  end
end
