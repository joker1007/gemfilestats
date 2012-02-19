class Repository
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, :type => String
  field :username, :type => String
  field :name, :type => String

  index :url, :unique => true
  index :username

  embeds_one :gemfile
  has_many :used_gems

  validates_presence_of :url, :username, :name

  before_validation do |record|
    record.url =~ /github\.com\/(.*?)\/(.*)\/?$/
    record.username = $1
    record.name = $2
  end

  def get_gemfile
    gemfile_body = GithubUtil.get_gemfile_body(self)
    self.create_gemfile({:body => gemfile_body})
  end
end
