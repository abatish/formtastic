module Formtastic
  class TagBuilder
    def initialize(template, scoped_html='')
      @scoped_html = scoped_html
      @template = template
    end

    def fieldset(*args, &block)
      create_tag(:fieldset, *args, &block)
    end

    def ol(*args, &block)
      create_tag(:ol, *args, &block)
    end

    def li(*args, &block)
      create_tag(:li, *args, &block)
    end

    def legend(*args, &block)
      create_tag(:legend, *args, &block)
    end

    protected
      def create_tag(*args)
        options = args.extract_options!
        tag_name = args.first
        value_or_html = args.second.to_s

        if block_given?
          yield self.class.new(@template, value_or_html)
        end

        @scoped_html << @template.content_tag(tag_name, Formtastic::Util.html_safe(value_or_html), options)
      end
  end
end
