class UsedGem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :url, :type => String
  field :version, :type => String
  field :group, :type => Array
  field :author, :type => String

  referenced_in :repository

  validates_presence_of :name

  before_save do |record|
    record.url = "http://rubygems.org/gems/#{record.name}"
  end

  def self.count_gems
    map = <<-EOS
      function() {
        emit(this.name, 1);
      }
    EOS
    reduce = <<-EOS
      function(name, values) {
        var total = 0;
        values.forEach(function(value) {
          total += value;
        });

        return {gem_count: total};
      }
    EOS

    UsedGem.collection.map_reduce(map, reduce, {out: {replace: "temp_gems"}})
  end
end
