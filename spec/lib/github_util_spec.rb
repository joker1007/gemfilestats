# coding: utf-8

require "spec_helper"

describe GithubUtil do
  let(:create_repo) {FactoryGirl.create(:repository)}
  it {
    GithubUtil.get_master_commit_url(create_repo).should =~ /https:\/\/api\.github\.com\/repo.*\/commits/
  }
end
