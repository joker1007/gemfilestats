require 'spec_helper'

describe Gemfile do
  it { should have_field(:sources).of_type(Array) }
  it { should have_field(:body).of_type(String) }
  it { should be_embedded_in(:repository) }

  describe "#get_used_gems" do
    subject { FactoryGirl.build(:gemfile) }

    it "should get sources & create used_gem" do
      subject.get_used_gems
      subject.sources.should eq(["https://rubygems.org"])
      subject.repository.used_gems.should have(7).items
    end

    it "should get used_gem group & version" do
      subject.get_used_gems
      [
        {name: 'rails', version: '3.2.1'},
        {name: 'sass-rails', version: '~> 3.2.3', group: [:assets]},
        {name: 'coffee-rails', version: '~> 3.2.1', group: [:assets]},
        {name: 'uglifier', version: '>= 1.0.3', group: [:assets]},
        {name: 'jquery-rails'},
        {name: 'rspec', version: '>= 2.5.0', group: [:test, :development]},
        {name: 'guard-spork', group: [:test]},
      ].each do |params|
        used_gem = subject.repository.used_gems.where(name: params[:name])[0]
        used_gem.version.should eq(params[:version])
        used_gem.group.should eq(params[:group])
      end
    end
  end
end
