class Repository
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, :type => String
  field :username, :type => String
  field :name, :type => String

  index :url, :unique => true
  index :username
  index :created_at

  embeds_one :gemfile
  has_many :used_gems, :dependent => :delete

  validates_presence_of :url, :username, :name
  validates_uniqueness_of :url
  validates_format_of :url, with: /https?:\/\/github\.com\/[\w\-]+\/[\w\-]+\/?$/

  before_validation do |record|
    record.url =~ /github\.com\/(.*?)\/(.*)\/?$/
    record.username = $1
    record.name = $2
  end

  after_save do |record|
    record.async_get_gemfile_and_used_gems
  end

  scope :recent, lambda {|n| order_by([[:created_at, :desc]]).limit(n)}

  def get_gemfile
    gemfile_body = GithubUtil.get_gemfile_body(self)
    self.create_gemfile({:body => gemfile_body})
  end

  def async_get_gemfile_and_used_gems
    Resque.enqueue(Job::GetUsedGemsJob, self.id)
  end
end
