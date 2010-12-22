module Formtastic
  class Tag
    def initialize(template)
      @template = template
    end

    def fieldset
      @template.content_tag :fieldset, yield(self)
    end

    def ol
      @template.content_tag :ol, yield(self)
    end

    def li(*args)
      options = args.extract_options!
      @template.content_tag :li, yield(self), options
    end

    def legend
      @template.content_tag :legend, yield
    end

    def label(*args)
      options = args.extract_options!
      @template.content_tag :label, yield, options
    end
  end
end
