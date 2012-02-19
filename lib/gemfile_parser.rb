module GemfileParser
  class << self
    def parse(body, block_group = nil)
      unless body.class == Sexp
        sexp = RubyParser.new.parse(body)
      else
        sexp = body
      end
      result = nil
      case sexp.sexp_type
      when :str
        result = sexp[1]
      when :lit
        result = sexp[1]
      when :array
        result = array_parse(sexp, block_group)
      when :hash
        result = hash_parse(sexp, block_group)
      when :call
        result = call_parse(sexp, block_group)
      when :iter
        result = iter_parse(sexp, block_group)
      when :block
        result = block_parse(sexp, block_group)
      end
      result
    end

    def array_parse(sexp, block_group = nil)
      sexp_body = sexp.sexp_body
      array = []
      sexp_body.each do |s|
        array.push(parse(s, block_group))
      end
      array
    end

    def hash_parse(sexp, block_group = nil)
      sexp_body = sexp.sexp_body
      hash = {}
      sexp_body.each_slice(2) do |list|
        hash.merge!({parse(list[0], block_group) => parse(list[1], block_group)})
      end
      hash
    end

    def call_parse(sexp, block_group = nil)
      method = sexp[2]
      arglist = sexp[3].sexp_body
      args = []
      arglist.each do |argexp|
        args.push(parse(argexp, block_group))
      end

      if method == :gem
        attrs = {:type => :gem, :name => args.shift, :version => nil, :group => block_group}
        attrs.merge!({:version => args.shift}) if args[0].class == String
        attrs.merge!(args.shift) if args[0].class == Hash
        return attrs
      end

      if method == :source
        attrs = {:type => :source, :url => args.shift}
        return attrs
      end

      if method == :group
        return [:group, args]
      end
    end

    def iter_parse(sexp, block_group = nil)
      sexp_body = sexp.sexp_body
      method, block_group = parse(sexp_body[0])
      result = nil
      if method == :group
        result = parse(sexp_body[2], block_group)
      end
      result
    end

    def block_parse(sexp, block_group = nil)
      result = []
      sexp.sexp_body.each do |s|
        result.push(parse(s, block_group))
      end
      result.flatten
    end
  end
end
