class UsedGem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :url, :type => String
  field :version, :type => String
  field :group, :type => Array
  field :author, :type => String

  referenced_in :repository
end
