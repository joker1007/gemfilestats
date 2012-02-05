class UsedGem
  include Mongoid::Document
  field :name, :type => String
  field :url, :type => String
  field :author, :type => String
end
