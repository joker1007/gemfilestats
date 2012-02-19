class Gemfile
  include Mongoid::Document

  field :sources, :type => Array, :default => []
  field :body, :type => String

  embedded_in :repository

  def get_used_gems
    if body
      GemfileParser.parse(body).each do |params|
        case params[:type]
        when :source
          sources.push(params[:url])
        when :gem
          params.delete(:type)
          params.delete(:require)
          if params[:group].class == String || params[:group].class == Symbol
            group = params[:group]
            params[:group] = [group]
          end
          repository.used_gems.create(params)
        end
      end
    end
  end
end
