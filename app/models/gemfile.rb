class Gemfile
  include Mongoid::Document
  field :body, :type => String

  embedded_in :repository
end
