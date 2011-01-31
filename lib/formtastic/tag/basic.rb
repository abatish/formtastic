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
    
    # Outputs a label and standard Rails text field inside the wrapper.
    def string_input(method, options)
      basic_input_helper(:text_field, :string, method, options)
    end

    # Outputs a label and standard Rails password field inside the wrapper.
    def password_input(method, options)
      basic_input_helper(:password_field, :password, method, options)
    end

    # Outputs a label and standard Rails text field inside the wrapper.
    def numeric_input(method, options)
      basic_input_helper(:text_field, :numeric, method, options)
    end

    # Ouputs a label and standard Rails text area inside the wrapper.
    def text_input(method, options)
      basic_input_helper(:text_area, :text, method, options)
    end

    # Outputs a label and a standard Rails file field inside the wrapper.
    def file_input(method, options)
      basic_input_helper(:file_field, :file, method, options)
    end

    # Outputs a label and a standard Rails email field inside the wrapper.
    def email_input(method, options)
      basic_input_helper(:email_field, :email, method, options)
    end

    # Outputs a label and a standard Rails phone field inside the wrapper.
    def phone_input(method, options)
      basic_input_helper(:phone_field, :phone, method, options)
    end

    # Outputs a label and a standard Rails url field inside the wrapper.
    def url_input(method, options)
      basic_input_helper(:url_field, :url, method, options)
    end

    # Outputs a label and a standard Rails search field inside the wrapper.
    def search_input(method, options)
      basic_input_helper(:search_field, :search, method, options)
    end
  end
end