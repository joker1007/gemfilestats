class Repository
  include Mongoid::Document
  field :url, :type => String
  field :username, :type => String
  field :name, :type => String

  embeds_one :gemfile

  validates_presence_of :url, :username, :name

  before_validation do |record|
    record.url =~ /github\.com\/(.*?)\/(.*)\/?$/
    record.username = $1
    record.name = $2
  end
end
