module Formtastic
  module Basic
    protected
    def basic_input_helper(form_helper_method, type, method, options) #:nodoc:
      html_options = options.delete(:input_html) || {}
      html_options = default_string_options(method, type).merge(html_options) if [:numeric, :string, :password, :text, :phone, :search, :url, :email].include?(type)
      field_id = generate_html_id(method, "")
      html_options[:id] ||= field_id
      label_options = options_for_label(options)
      label_options[:for] ||= html_options[:id]

      text = options.delete(:label)

      text = localized_string(method, text, :label) || humanized_attribute_name(method)
      text += required_or_optional_string(options.delete(:required))
      text = Formtastic::Util.html_safe(text)

      # special case for boolean (checkbox) labels, which have a nested input
      if options.key?(:label_prefix_for_nested_input)
        text = options.delete(:label_prefix_for_nested_input) + text
      end
      
      tag = tag_builder.new
      unless label_options[:label] == false
        tag.label(label_options) do |label|
          label.content text
        end
      end
      tag.content self.send(self.respond_to?(form_helper_method) ? form_helper_method : :text_field, method, html_options)
    end
  end
end