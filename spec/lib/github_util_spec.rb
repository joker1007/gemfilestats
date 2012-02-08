# coding: utf-8

require "spec_helper"

describe GithubUtil do
  let(:create_repo) {FactoryGirl.create(:repository)}

  describe ".get_master_commit_url" do
    context "リポジトリがある時" do
      it {
        GithubUtil.get_master_commit_url(create_repo).should =~ /https:\/\/api\.github\.com\/repo.*\/commits/
      }
    end

    context "リポジトリがない時" do
      let(:create_repo) {FactoryGirl.create(:repository, :url => "https://github.com/hogehogehogehogehogehogefuga1240193982/none_repository")}
      it {
        expect {
          GithubUtil.get_master_commit_url(create_repo)
        }.to raise_error(OpenURI::HTTPError)
      }
    end
  end

  describe ".get_tree_url" do
    context "masterコミットを示すURLがある時" do
      it {
        GithubUtil.should_receive(:get_master_commit_url).with(create_repo).and_return("https://api.github.com/repos/joker1007/pasokara_player3/git/commits/6624acc21c0f713b51d8ca56681dcb9b6cea61fb")
        GithubUtil.get_tree_url(create_repo).should =~ /https:\/\/api\.github\.com\/repo.*\/trees/
      }
    end

    context "masterコミットを示すURLがない時" do
      let(:create_repo) {FactoryGirl.create(:repository, :url => "https://github.com/hogehogehogehogehogehogefuga1240193982/none_repository")}
      it {
        expect {
          GithubUtil.get_tree_url(create_repo)
        }.to raise_error(OpenURI::HTTPError)
      }
    end
  end

  describe ".get_gemfile_url" do
    context "treeを示すURLがある時" do
      it {
        GithubUtil.should_receive(:get_tree_url).with(create_repo).and_return("https://api.github.com/repos/joker1007/pasokara_player3/git/trees/ae24603f46839c215204d6bff103ef9cea4511f0")
        GithubUtil.get_gemfile_url(create_repo).should =~ /https:\/\/api\.github\.com\/.*\/git\/blobs/
      }
    end

    context "treeのURL取得過程でOpenURI::HTTPErrorが発生した時" do
      let(:create_repo) {FactoryGirl.create(:repository, :url => "https://github.com/hogehogehogehogehogehogefuga1240193982/none_repository")}
      it {
        expect {
          GithubUtil.get_gemfile_url(create_repo)
        }.to raise_error(OpenURI::HTTPError)
      }
    end
  end

  describe ".get_gemfile_body" do
    context "Gemfileのblobを示すURLがある時" do
      it {
        GithubUtil.should_receive(:get_gemfile_url).with(create_repo).and_return("https://api.github.com/repos/joker1007/pasokara_player3/git/blobs/84df8620d6299d9a0b58ab981e1bdf5d7be27d75")
        GithubUtil.get_gemfile_body(create_repo).should =~ /rubygems\.org/
      }
    end

    context "Gemfileのblobを示すURLがある時" do
      let(:create_repo) {FactoryGirl.create(:repository, :url => "https://github.com/hogehogehogehogehogehogefuga1240193982/none_repository")}
      it {
        GithubUtil.get_gemfile_body(create_repo).should be_nil
      }
    end
  end
end
